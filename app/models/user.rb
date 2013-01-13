class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :login
  # attr_accessible :title, :body
  attr_accessor :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  has_many :created_projects,
  :foreign_key => 'creator_id',
  :class_name => 'Project'

  has_many :permissions

  has_many :projects,
  :through => :permissions,
  :source => :entity,
  :source_type => "Project"

  def get_home_path
    Rails.root.join 'workspace', Digest::MD5.hexdigest(self.email)
  end

end
