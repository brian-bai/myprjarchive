class ProfilesController < ApplicationController
  before_filter :get_target_user
  def new
    @target_user.build_profile if @target_user.profile.nil? 
    @profile = @target_user.profile
  end

  def show
    @profile = @target_user.profile
    if @profile.nil? 
      redirect_to(new_user_profile_path(@target_user), :notice => 'No profile.')
    end
  end
  def create
    @profile = @target_user.build_profile(params[:profile])

    if @profile.save
      redirect_to(user_profile_path(@target_user), :notice => 'Profile was successfully created.') 
    else
      render 'new'
    end
  end
  def update
    @profile = @target_user.profile

    if @profile.update_attributes(params[:profile])
      redirect_to(user_profile_path(@target_user), :notice => 'Profile was successfully updated.') 
    else
      render 'edit'
    end
  end
  def edit
    @profile = @target_user.profile
  end
  private 
    def get_target_user
      @target_user = User.find(params[:user_id])
    end
end
