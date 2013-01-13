class ProjectAuthorizer < ApplicationAuthorizer

  def self.creatable_by?(user)
    # Anyone can create a project
    # [TODO] Limit the number of projects a user can create
    true
  end

  def check_permission(ability, user)
    Permission.where("user_id=? and can_#{ability}=? and entity_id=? and entity_type=?",user.id,1,resource.id,'Project').count > 0
  end

  def readable_by?(user)
    check_permission('read', user)
  end

  def editable_by?(user)
    check_permission('edit', user)
  end

  def administrable_by?(user)
    check_permission('administer', user)
  end
end
