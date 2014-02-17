class CreateProfileAttributes < ActiveRecord::Migration
  def self.up
    create_table :profile_attributes do |t|
      t.string :type
      t.string :value
      t.integer :profile_id

      t.timestamps
    end
  end

  def self.down
    drop_table :profile_attributes
  end
end
