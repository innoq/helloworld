class SplitNameFirstLast < ActiveRecord::Migration
  def self.up
    remove_column :profiles, :name
    add_column :profiles, :first_name, :string
    add_column :profiles, :last_name, :string
  end

  def self.down
    add_column :profiles, :name, :string
    remove_column :profiles, :first_name
    remove_column :profiles, :last_name
  end
end
