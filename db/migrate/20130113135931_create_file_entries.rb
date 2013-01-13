class CreateFileEntries < ActiveRecord::Migration
  def change
    create_table :file_entries do |t|

      t.timestamps
    end
  end
end
