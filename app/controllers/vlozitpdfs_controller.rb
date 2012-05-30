# coding: utf-8

class VlozitpdfsController < ApplicationController
  # GET /vlozitpdfs
  # GET /vlozitpdfs.xml
  def index
    @vlozitpdfs = Vlozitpdf.all
    user = User.find_by_username(fel_id[:user_id])
    if user
      @purchases = Purchase.where("user_id = ?", user.id)
      @paid = false
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vlozitpdfs }
    end
  end

  # GET /vlozitpdfs/1
  # GET /vlozitpdfs/1.xml
  def show
    
    @vlozitpdf = Vlozitpdf.find(params[:id])
    user = User.find_by_username(fel_id[:user_id])
    if user
      @purchases = Purchase.where("user_id = ?", user.id)
      @paid = false
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vlozitpdf }
    end
  end

  # GET /vlozitpdfs/new
  # GET /vlozitpdfs/new.xml
  def new
    @vlozitpdf = Vlozitpdf.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vlozitpdf }
    end
  end

  # GET /vlozitpdfs/1/edit
  def edit
    @vlozitpdf = Vlozitpdf.find(params[:id])

    if fel_id[:user_id] != @vlozitpdf.vlozil && !is_admin
      redirect_to(@vlozitpdf, :notice => 'Nemátě oprávnění upravovat tento dokument')
      return
    end

  end

  # POST /vlozitpdfs
  # POST /vlozitpdfs.xml
  def create
    if !params[:invoice].nil?
      redirect_to vlozitpdfs_path
      return
    end

    @vlozitpdf = Vlozitpdf.new(params[:vlozitpdf])
    @vlozitpdf.vlozil = fel_id[:user_id]
		@vlozitpdf.hashString = ActiveSupport::SecureRandom.base64(8).gsub(/[^0-9A-Za-z]/, '')
		@vlozitpdf.soubor_file_name = @vlozitpdf.soubor_file_name.gsub(/[^0-9A-Za-z.]/, '')

    user = User.find_by_username(fel_id[:user_id])
    if !user
      user = User.new(:username => fel_id[:user_id], :uploaded => @vlozitpdf.soubor_file_size)
      user.save!
    else
      configuration = Configuration.find_by_key("user_upload_quota")
      if configuration 
        quota = configuration.value.to_i
      else
        quota = 5000000
      end
      logger.info quota
      if user.uploaded + @vlozitpdf.soubor_file_size >= quota
        logger.info "quota exceeded"
        redirect_to :root
        return
      end  
    end

    respond_to do |format|
      if @vlozitpdf.save
        format.html { redirect_to(@vlozitpdf, :notice => 'Soubor úspěšně nahrán.') }
        format.xml  { render :xml => @vlozitpdf, :status => :created, :location => @vlozitpdf }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vlozitpdf.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vlozitpdfs/1
  # PUT /vlozitpdfs/1.xml
  def update
    @vlozitpdf = Vlozitpdf.find(params[:id])

    if fel_id[:user_id] != @vlozitpdf.vlozil && !is_admin
      redirect_to(@vlozitpdf, :notice => 'Nemátě oprávnění upravovat tento dokument')
      return
    end

    respond_to do |format|
      if @vlozitpdf.update_attributes(params[:vlozitpdf])
        format.html { redirect_to(@vlozitpdf, :notice => 'Atributy upraveny.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vlozitpdf.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vlozitpdfs/1
  # DELETE /vlozitpdfs/1.xml
  def destroy
    @vlozitpdf = Vlozitpdf.find(params[:id])

    if fel_id[:user_id] != @vlozitpdf.vlozil && !is_admin
      redirect_to(@vlozitpdf, :notice => 'Nemátě oprávnění upravovat tento dokument')
      return
    end

    @vlozitpdf.destroy

    respond_to do |format|
      format.html { redirect_to(vlozitpdfs_url) }
      format.xml  { head :ok }
    end
  end
end
