class Project < ActiveRecord::Base
  attr_accessible :name, :root, :creator
  belongs_to :creator, :class_name => "User"

  has_many :permissions, :as => :entity
end
