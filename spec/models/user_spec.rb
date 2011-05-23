require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => "Name", :email => "example@example.com" }
  end
  
  it "Should create a new instance given a valid attribute" do
    User.create!(@attr)
  end
  
  it "Should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "Should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "Should reject names that are too long" do
    long_name = "_" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "Should accept valid email addresses" do
    addresses = %w[user@example.com CAPS@ex.ample.com first.last@example.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "Should reject invalid email addresses" do
    addresses = %w[user@example,com CAPS_ex.ample.com first.last@example.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "Should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "Should reject emaild addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
end
