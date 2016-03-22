require 'spec_helper'

describe ProfilesController do
  render_views

  before(:each) do
    @user = Factory(:user)
  end

  describe "GET 'new'" do
    it "should success" do
      get :new, :user_id => @user
      response.should be_success
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @profile = Factory.build(:profile, :user_id => @user)
    end
    it "should success" do
      post :create, :user_id => @user, :profile => @profile
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should redirect to new path" do
      get :show, :user_id => @user
      response.should redirect_to(new_user_profile_path(@user))
    end
    it "should success" do
      @profile = Factory(:profile, :user_id => @user)
      get :show, :user_id => @user, :profile => @profile
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should success" do
      @profile = Factory(:profile, :user_id => @user)
      get :edit, :user_id => @user, :profile => @profile 
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @profile = Factory(:profile, :user_id => @user)
    end
    it "should success" do
      put :update, :user_id => @user, :profile => @profile
      response.should redirect_to(user_profile_path(@user))
    end
  end
end
