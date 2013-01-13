class Permission < ActiveRecord::Base
  attr_accessible :user, :entity
  belongs_to :user
  belongs_to :entity, :polymorphic => true
end
