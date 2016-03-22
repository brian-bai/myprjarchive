class NotesController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :destroy]
  # GET /notes
  # GET /notes.xml
  def index
    #@notes = Note.all
    if signed_in?
      @notes = Note.paginate(:page => params[:page], :conditions => [ "openlevel = ? OR user_id = ? ", 1, current_user.id], :order => 'created_at DESC', :per_page => 9)
#      @notes = Note.order("created_at DESC").where("openlevel = ? OR user_id = ?", 1, current_user.id)
    else
      #@notes = Note.order("created_at DESC").where("openlevel = ?", 1)
      @notes = Note.paginate(:page => params[:page], :conditions => [ "openlevel = 1"], :order => 'created_at DESC', :per_page => 9)
    end
 
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notes }
      format.rss  { render :layout => false }
    end
  end

  # GET /notes/1
  # GET /notes/1.xml
  def show
    @note = Note.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/new
  # GET /notes/new.xml
  def new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])
  end

  # POST /notes
  # POST /notes.xml
  def create
    @note = Note.new(params[:note].merge(:user_id => current_user.id, :writer => current_user.name))

    respond_to do |format|
      if @note.save
        format.html { redirect_to(notes_path, :notice => 'Note was successfully created.') }
        flash.now[:notice] = "Successfully created note."
        format.xml { head :ok }
      else
        format.html { render :action => "new" }
        format.xml { head :ok }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    @note = Note.find(params[:id])

    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { redirect_to(notes_path, :notice => 'Note was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    if !signed_in? 
      
    else
      @note = Note.find(params[:id])
      @note.destroy
    end

    respond_to do |format|
      format.html { redirect_to(notes_url) }
      format.xml { head :ok }
    end
  end

end
