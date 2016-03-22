require 'spec_helper'

describe History do
  before(:each) do
    @attr = { 
      :user_id => 1,
      :company => "E-CAREER Co.Ltd",
      :position => "Software Engineer",
      :startdate => Date.today - 20.years,
      :enddate => Date.today - 10.days,
      :details => "Employment history details"
    }
  end

  it "should create a new instance given valid attributes" do
    History.create!(@attr)
  end

  it "should requrire a user_id" do
    no_id = History.new(@attr.merge(:user_id => nil))
    no_id.should_not be_valid
  end

  it "should require a comapny" do
    no_co = History.new(@attr.merge(:company => ""))
    no_co.should_not be_valid
  end

  it "should reject too long company" do
    company = "a" * 101
    long_co = History.new(@attr.merge(:company => company))
    long_co.should_not be_valid
  end

  it "should require a position" do
    no_po = History.new(@attr.merge(:position => ""))
    no_po.should_not be_valid
  end

  it "should reject too long position" do
    position = "b" * 51
    long_po = History.new(@attr.merge(:position => position))
    long_po.should_not be_valid
  end

  it "should require a startdate" do
    no_start = History.new(@attr.merge(:startdate => nil))
    no_start.should_not be_valid
  end
  it "should require a detail" do
    no_detail = History.new(@attr.merge(:details => ""))
    no_detail.should_not be_valid
  end
  it "should reject a too long detail" do
    details = "d" * 10001
    long_de = History.new(@attr.merge(:details => details))
    long_de.should_not be_valid
  end




end
