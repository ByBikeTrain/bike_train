class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :photo

  has_many :groupMemberships
  has_many :groups, :through => :groupMemberships

  has_many :messages, :foreign_key => :recipient_id
  
  has_secure_password

  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50}

  VALID_EMAIL_REGEX = /\A[\w\-.\+]+@[a-z\d\-.]+\.+[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }   
  validates :password, presence: true, length: { minimum: 6}
  validates :password_confirmation, presence: true

  has_attached_file :photo, styles: { small: "120x120<" },
                    default_url: "/assets/missing120x120.png",
   					        url: "/assets/users/:id/:style/:basename.:extension",
                  	path: ":rails_root/public/assets/users/:id/:style/:basename.:extension"

  validates_attachment_size :photo, :less_than => 3.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  private 
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64  
  end
end
