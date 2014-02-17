class CreateRelations < ActiveRecord::Migration
  def self.up
    create_table :relations do |t|
      t.integer :source_id
      t.integer :target_id
      t.string :comment
      t.boolean :accepted

      t.timestamps
    end
  end

  def self.down
    drop_table :relations
  end
end
