require "spec_helper"

describe HistoriesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/users/1/histories" }.should route_to(:controller => "histories", :action => "index", :user_id => "1")
    end

    it "recognizes and generates #new" do
      { :get => "/users/1/histories/new" }.should route_to(:controller => "histories", :action => "new", :user_id => "1")
    end

    it "recognizes and generates #show" do
      { :get => "/users/1/histories/1" }.should route_to(:controller => "histories", :action => "show", :user_id => "1", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/users/1/histories/1/edit" }.should route_to(:controller => "histories", :action => "edit", :user_id => "1", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/users/1/histories" }.should route_to(:controller => "histories", :action => "create", :user_id => "1")
    end

    it "recognizes and generates #update" do
      { :put => "/users/1/histories/1" }.should route_to(:controller => "histories", :action => "update", :id => "1", :user_id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/users/1/histories/1" }.should route_to(:controller => "histories", :action => "destroy", :id => "1", :user_id => "1")
    end

  end
end
