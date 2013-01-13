class Permission < ActiveRecord::Base
  attr_accessible :user, :entity, :can_read, :can_edit, :can_administer
  belongs_to :user
  belongs_to :entity, :polymorphic => true
end
