require 'fileutils'

class Project < ActiveRecord::Base

  include Authority::Abilities
  self.authorizer_name = 'ProjectAuthorizer'

  attr_accessible :name, :root, :creator, :is_public
  belongs_to :creator, :class_name => "User"

  has_many :permissions, :as => :entity

  validates :name, :presence => true
  validates :name, :length => {
    :minimum => 1
  }
  validates :name, :format => {
    :with => /^\S*$/,
    :message => 'Spaces are not allowed'
  }

  before_save do |project|
    project.root = project.creator.get_home_path.join(project.name).to_s
  end

  after_create do |project|
    permission = Permission.new({
      :can_read => true,
      :can_edit => true,
      :can_administer => true
    })
    permission.user = project.creator
    permission.entity = project
    permission.can_administer
    permission.save

    # [TODO] Handle EACCES : Permission denied
    FileUtils.mkpath project.root
  end
end
