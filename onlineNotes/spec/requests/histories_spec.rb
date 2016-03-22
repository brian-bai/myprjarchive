require 'spec_helper'

describe "Histories" do
  describe "GET /histories" do
    it "works! (now write some real specs)" do
      @user = Factory(:user)
      get user_histories_path(@user)
    end
  end
end
