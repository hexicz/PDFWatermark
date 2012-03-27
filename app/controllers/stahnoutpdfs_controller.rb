#coding: utf-8

class StahnoutpdfsController < ApplicationController

@@UHEL = 45
@@VELIKOSTPISMAU = 80
@@BARVAPISMA = "c0c0c0"
@@FONT = "Helvetica"

  private  
    def generujHeslo(length=8)
      chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'
      password = ''
      length.times { password << chars[rand(chars.size)] }
      password
    end

  public 
    def stahnoutpdfko
      #@pdfko = Vlozitpdf.find(params[:hashString])      
      @pdfko = Vlozitpdf.find(:first, :conditions =>["hashString = ?",params[:hashString]])
			@username = fel_id[:user_id]
    	@hostname = self.request.host
    	@opravneni = 00
    	@velikostPapiru = "A4"
    	@soubor = @pdfko.soubor_file_name
    	@footerText = @pdfko.paticka
      
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
      
      system("pdftk #{Rails.root}/public/pdf/#{@soubor}.pdf background #{Rails.root}/tmp/pdf/tmp_#{@username}_#{@soubor}.pdf output #{Rails.root}/tmp/pdf/#{@soubor}_#{@username}.pdf owner_pw #{@pdfHeslo} #{@setPerm}")
      
      system("rm -rf #{Rails.root}/tmp/pdf/tmp_#{@username}_#{@soubor}.pdf")
      
      send_file "#{Rails.root}/tmp/pdf/#{@soubor}_#{@username}.pdf", :type => "application/pdf"

    end
    
end
  
