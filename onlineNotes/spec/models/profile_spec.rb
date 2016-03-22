require 'spec_helper'

describe Profile do

  before(:each) do
    @attr = {
      :user_id => 1,
      :birthday => Date.today - 20.years,
      :gender => "m",
      :address => "Tokyo",
      :phone => "123456789"
    }
  end

  it "should create a new instance given valid attributes" do
    Profile.create!(@attr)
  end

  it "should require a user id" do
    no_id_profile = Profile.new(@attr.merge(:user_id => nil))
    no_id_profile.should_not be_valid
  end

  it "should require a birthday" do
    no_birthday_profile = Profile.new(@attr.merge(:birthday => nil))
    no_birthday_profile.should_not be_valid
  end

  it "should require a gender" do
    no_gender_profile = Profile.new(@attr.merge(:gender => ""))
    no_gender_profile.should_not be_valid
  end

  it "should require a address" do
    no_address_profile = Profile.new(@attr.merge(:address => ""))
    no_address_profile.should_not be_valid
  end

  it "should require a phone" do
    no_phone_profile = Profile.new(@attr.merge(:phone => ""))
    no_phone_profile.should_not be_valid
  end

  it "should reject the invalid phone number format" do
    in_valid_phone_profile = Profile.new(@attr.merge(:phone => "1234abc"))
    in_valid_phone_profile.should_not be_valid
  end

  it "should reject phones that are too short" do
    short_phone = "12345"
    short_phone_profile = Profile.new(@attr.merge(:phone => short_phone))
    short_phone_profile.should_not be_valid
  end

  it "should reject phones that are too long" do
    long_phone = "1234567890"
    long_phone_profile = Profile.new(@attr.merge(:phone => long_phone))
    long_phone_profile.should_not be_valid
  end
end
