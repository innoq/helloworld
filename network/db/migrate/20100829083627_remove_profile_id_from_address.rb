class RemoveProfileIdFromAddress < ActiveRecord::Migration
  def self.up
    remove_column :addresses, :profile_id
  end

  def self.down
    add_column :addresses, :profile_id, :integer
  end
end
