class Project < ActiveRecord::Base

  include Authority::Abilities
  self.authorizer_name = 'ProjectAuthorizer'

  attr_accessible :name, :root, :creator
  belongs_to :creator, :class_name => "User"

  has_many :permissions, :as => :entity
end
