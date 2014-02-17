class RenameTypeInAttribute < ActiveRecord::Migration
  def self.up
    rename_column :profile_attributes, :type, :attr_type
  end

  def self.down
    rename_column :profile_attributes, :attr_type, :type
  end
end
