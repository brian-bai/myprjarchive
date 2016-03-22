class HistoriesController < ApplicationController
  before_filter :get_target_user
  # GET /histories
  # GET /histories.xml
  def index
    @histories = @target_user.histories.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @histories }
    end
  end

  # GET /histories/1
  # GET /histories/1.xml
  def show
    @history = History.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @history }
    end
  end

  def preview
    @histories = @target_user.histories.all
    @profile = @target_user.profile ? @tartget_user.profile : @target_user.build_profile

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @history }
    end
  end

  # GET /histories/new
  # GET /histories/new.xml
  def new
    @history = @target_user.histories.build 

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @history }
    end
  end

  # GET /histories/1/edit
  def edit
    @history = History.find(params[:id])
  end

  # POST /histories
  # POST /histories.xml
  def create
    @history = @target_user.histories.build(params[:history])

    respond_to do |format|
      if @history.save
        format.html { redirect_to(user_history_path(@target_user,@history), :notice => 'History was successfully created.') }
        format.xml  { render :xml => @history, :status => :created, :location => @history }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @history.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /histories/1
  # PUT /histories/1.xml
  def update
    @history = History.find(params[:id])

    respond_to do |format|
      if @history.update_attributes(params[:history])
        format.html { redirect_to(@history, :notice => 'History was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @history.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /histories/1
  # DELETE /histories/1.xml
  def destroy
    @history = History.find(params[:id])
    @history.destroy

    respond_to do |format|
      format.html { redirect_to(user_histories_url(@target_user)) }
      format.xml  { head :ok }
    end
  end
  private 
    def get_target_user
      @target_user = User.find(params[:user_id])
    end
end
