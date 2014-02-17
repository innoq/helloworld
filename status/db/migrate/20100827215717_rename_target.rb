class RenameTarget < ActiveRecord::Migration
  def self.up
    rename_column :relations, :target_id, :destination_id
  end

  def self.down
    rename_column :relations, :destination_id, :target_id
  end
end
