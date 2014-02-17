class RemoveStupidTimestamps < ActiveRecord::Migration
  def self.up
    remove_column :profile_attributes, :created_at
    remove_column :profile_attributes, :updated_at
    remove_column :addresses, :created_at
    remove_column :addresses, :updated_at
  end

  def self.down
    add_column :profile_attributes, :created_at, :timestamp
    add_column :profile_attributes, :updated_at, :timestamp
    add_column :addresses, :created_at, :timestamp
    add_column :addresses, :updated_at, :timestamp
  end
end
