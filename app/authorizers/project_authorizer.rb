class ProjectAuthorizer < ApplicationAuthorizer
  def self.creatable_by?(user)
    # Anyone can create a project
    # [TODO] Limit the number of projects a user can create
    true
  end
  def self.editable_by?(user)
    false
  end
  def self.administrable_by?(user)
    false
  end
end
