class FileAuthorizer < ApplicationAuthorizer

  def check_permission(ability, user)
    return true if user.send "can_#{ability}", resource.project
    file_entry = FileEntry.where('path=?', resource.path)
    return false if file_entry.nil?
    Permission.where("user_id=? and can_#{ability}=? and entity_id=? and entity_type=?",user.id,1,file_entry.id,'FileEntry').count > 0
  end

  def readable_by?(user)
    check_permission('read', user)
  end

  def editable_by?(user)
    check_permission 'edit', user
  end

  def administrable_by?(user)
    check_permission 'administer', user
  end

end
