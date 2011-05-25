# == Schema Information
# Schema version: 20110523214714
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

class User < ActiveRecord::Base
  attr_accessor :password
  
  # Set which fields should be accessible by the user
  attr_accessible :name, :email, :password, :password_confirmation
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
  validates :email, :presence     => true,
                    :uniqueness   => { :case_sensitive => false },
                    :format       => { :with => email_regex }
  validates :password, :presence => true,
                       :confirmation => true, # validates with password_confirmation
                       :length => { :within => 6..40 }
                       
  before_save :encrypt_password
  
  # check if the password in the database maches what is passed in
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  # Defining a class method. Other syntax as follows:
  # class << self
  #   def method()
  #   end
  # end
  def User.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  def User.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  private
  
    def encrypt_password
      self.salt = make_salt if new_record? # only make salt if this is new item
      self.encrypted_password = encrypt(self.password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
end
