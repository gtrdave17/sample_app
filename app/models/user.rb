
require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible(:name, :email, :password, :password_confirmation)

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates(:name, :presence => true)
  validates(:name, :length => {:maximum => 50  })

  validates(:email, :presence => true)
  validates(:email, :format => {:with => email_regex })
  validates(:email, :uniqueness => {:case_sensitive => false  })

  #ch 7, automatically create the virtual attribute 'password confirmation'.
  validates(:password, :presence => true)
  validates(:password, :confirmation => true)
  validates(:password, :length => { :within => 6..40  })

  before_save :encrypt_password
  
  #return true if the user's password matches the submitted password. 
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  

  
  private
  
  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
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

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
    #could have also used these two lines in place of the one line above
    # return nil  if user.nil?
    # return user if user.salt == cookie_salt
    # In both cases, the method returns the user if user is not nil and the user salt 
    # matches the cookie’s salt, and returns nil otherwise.
  end
end
