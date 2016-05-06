require 'digest/sha1'
require 'digest/sha2'

class User < ActiveRecord::Base
  set_table_name :users
  set_primary_key :user_id

  #before_save :set_password
  has_many :user_roles, :foreign_key => :user_id
  has_many :suggestions, :foreign_key => :user_id
  has_many :votes, :foreign_key => :user_id
  cattr_accessor :current_user

  validates_uniqueness_of :phone_number, :message => 'Phone number already taken'
  def try_to_login
    User.authenticate(self.username,self.password)
  end

  def self.authenticate(login, password)
    u = find :first, :conditions => {:phone_number => login}
    u && u.authenticated?(password) ? u : nil
  end

  def authenticated?(plain)
    encrypt(plain, salt) == password || Digest::SHA1.hexdigest("#{plain}#{salt}") == password || Digest::SHA512.hexdigest("#{plain}#{salt}") == password
  end

  def encrypt(plain, salt)
    encoding = ""
    digest = Digest::SHA1.digest("#{plain}#{salt}")
    (0..digest.size-1).each{|i| encoding << digest[i].to_s(16) }
    encoding
  end

  def set_password
    self.salt = User.random_string(10) if !self.salt?
    self.password = User.encrypt(self.password,self.salt)
  end

  def self.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def self.encrypt(password,salt)
    Digest::SHA1.hexdigest(password+salt)
  end

  def role
    u_role = self.user_roles.last
    return "" if u_role.blank?
    return u_role.role
  end

  def participated_in_competition(competition_id)
    votes = self.votes.find(:all, :conditions => ["voting_type_id =?", competition_id])
    return false if votes.blank?
    return true
  end
  
end
