class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :creator_id
      t.string :root
      t.boolean :is_public
      t.timestamps
    end
  end
end
