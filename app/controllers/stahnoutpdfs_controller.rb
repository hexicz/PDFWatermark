#coding: utf-8

class StahnoutpdfsController < ApplicationController

@@UHEL = 45
@@VELIKOSTPISMAU = 80
@@BARVAPISMA = "c0c0c0"
@@FONT = "Helvetica"

  private 
    # generate random password 
    def generujHeslo(length=8)
      chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'
      password = ''
      length.times { password << chars[rand(chars.size)] }
      password
    end

  public 
    #download PDF with watermark if possible (user is logged or pdf distribution is set to free or user has paid for PDF)
    def stahnoutpdfko  
      @pdfko = Vlozitpdf.find(:first, :conditions =>["hashString = ?",params[:hashString]])
      @hostname = self.request.host

      if @pdfko.tisk && @pdfko.kopirovat
        @opravneni = 11
      elsif !@pdfko.tisk && @pdfko.kopirovat
        @opravneni = 10
      elsif @pdfko.tisk && !@pdfko.kopirovat
        @opravneni = 01
      else
        @opravneni = 00
      end   

      @velikostPapiru = "A4"
      @soubor = @pdfko.soubor_file_name
      @footerText = @pdfko.paticka
      @username = fel_id[:user_id] 

      if params[:is_free].present? 
        if params[:is_free] == "free" 
          if @pdfko.distribuce == "Zdarma pro všechny"
            if fel_id[:user_id].nil?
              @username = "anonym"
            end
          else
            logger.info "Nepovoleno"
            session[:hash_string] = @pdfko.hashString
            # přistupuje přes free adresu na dokument, který není určen pro stažení zdarma
            redirect_to :action => :nepovoleno
            return
          end
        else
          raise ActionController::RoutingError.new("Not Found")
        end
      end

      if @pdfko.distribuce == "Placeně"
        logger.info "placená distribuce"
        paid = false
        if fel_id[:user_id].nil?
          session[:hash_string] = @pdfko.hashString
          # přistupuje přes free adresu na dokument, který není určen pro stažení zdarma
          redirect_to :action => :nepovoleno 
          return
        else
            user = User.find_by_username(fel_id[:user_id])
            if user
              purchases = Purchase.where("user_id = ?", user.id)
            end
            if !purchases.nil?
              logger.info "uvnitř purchases" 
              purchases.each do |purchase| 
                if purchase.pdf_id == @pdfko.id && !purchase.purchased_at.nil?
                  logger.info "paid true for #{@pdfko.id} and #{purchase.id}"
                  paid = true
                end
              end
            end
        end

        if paid == false
          session[:hash_string] = @pdfko.hashString
          session[:pdf_id] = @pdfko.id
          # přistupuje přes free adresu na dokument, který není určen pro stažení zdarma
          redirect_to :action => :nezaplaceno
          return
        end  
      end

      pdf = Prawn::Document.generate("#{Rails.root}/tmp/pdf/tmp_#{@username}_#{@soubor}", :page_size => @velikostPapiru, :page_layout => :portrait, :left_margin => 0, :right_margin => 0, :top_margin => 0, :bottom_margin => 0) do |pdf|
        pdf.font @@FONT
        
        #------------------------------------------------------------------------------------------------
        #   VYPOCET A UMISTENI SIKMEHO VODOTISKU NA STRED STRANKY
        #------------------------------------------------------------------------------------------------
        _delkaTextu = pdf.width_of(@username, :size => @@VELIKOSTPISMAU)
        _vyskaTextu = @@VELIKOSTPISMAU
        page_width = pdf.bounds.bottom_right[0]
        page_height = pdf.bounds.top_left[1]
        
        _textXpozice = (page_width/2) - (_delkaTextu/2)
        _textYpozice = (page_height/2) - (_vyskaTextu/2)
        
        #---posun stredu po rotaci
        _uhloprickaPul = Math.sqrt(_delkaTextu * _delkaTextu + _vyskaTextu * _vyskaTextu) / 2

        _vertikalniPosun = Math.sin(@@UHEL) * _uhloprickaPul - (_vyskaTextu / 2)
        _finalYpozice = _textYpozice - _vertikalniPosun

        _horizontalniPosun = (_delkaTextu / 2) - Math.cos(@@UHEL) * _uhloprickaPul
        _finalXpozice = _textXpozice + _horizontalniPosun

        pdf.fill_color @@BARVAPISMA
        pdf.draw_text(@username, :at => [_finalXpozice, _finalYpozice], :size => @@VELIKOSTPISMAU, :rotate => @@UHEL)
        
        #------------------------------------------------------------------------------------------------
        #   UMISTENI VODOTISKU DO HLAVICKY A PATICKY STRANKY
        #------------------------------------------------------------------------------------------------    
        datum = Time.new
        datumFormatted = datum.strftime("%d.%m.%Y %H:%M:%S")

        headerText = "Staženo uživatelem #{@username} z #{@hostname}, " + datumFormatted
        if @footerText == 0
          @footerText = headerText
        end

        pdf.text_box(@footerText, :size => 11, :at => [0,20], :align => :center)
        pdf.text_box(headerText, :size => 11, :at => [0, page_height - 15], :width => page_width, :align => :center)
        pdf.fill_color "ffffff"
        pdf.text_box(headerText, :size => 1, :at => [0, page_height - 30], :width => page_width, :align => :center)

        for i in (1..4)
          @soubor.chop!
        end
        
      end #konec generovani PDF
      
      #--generator nahodneho hesla owner_pw
      @pdfHeslo = generujHeslo
      
      #--nastaveni opravneni pdf
      case @opravneni
        when 00 #vse zakazano
          @setPerm = ""
        when 01 #pouze tisk
          @setPerm = "allow printing"
        when 10 #pouze kopirovani
          @setPerm = "allow copycontents"
        when 11 #tisk a kopirovani
          @setPerm = "allow printing copycontents"
      end
      
      # Vložení vodoznaku do pozadí dokumentu
      # system("pdftk #{Rails.root}/public/pdf/#{@soubor}.pdf background #{Rails.root}/tmp/pdf/tmp_#{@username}_#{@soubor}.pdf output #{Rails.root}/tmp/pdf/#{@soubor}_#{@username}.pdf owner_pw #{@pdfHeslo} #{@setPerm}")
      # Vložení vodoznaku do popředí dokumentu
      system("pdftk #{Rails.root}/public/pdf/#{@soubor}.pdf stamp #{Rails.root}/tmp/pdf/tmp_#{@username}_#{@soubor}.pdf output #{Rails.root}/tmp/pdf/#{@soubor}_#{@username}.pdf owner_pw #{@pdfHeslo} #{@setPerm}")

      system("rm -rf #{Rails.root}/tmp/pdf/tmp_#{@username}_#{@soubor}.pdf")
      
      send_file "#{Rails.root}/tmp/pdf/#{@soubor}_#{@username}.pdf", :type => "application/pdf"

    end

    # user isn't logged
    def nepovoleno
      @hash_string = session[:hash_string]
    end

    # user haven't paid for PDF
    def nezaplaceno
      @pdf_id = session[:pdf_id]
    end
    
end
  
