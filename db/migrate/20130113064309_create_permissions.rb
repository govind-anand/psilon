class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :user_id
      t.integer :entity_id
      t.string :entity_type
      t.integer :can_read
      t.integer :can_edit
      t.integer :can_administer
      t.timestamps
    end
  end
end
