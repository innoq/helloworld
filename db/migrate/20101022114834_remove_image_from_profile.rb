class RemoveImageFromProfile < ActiveRecord::Migration
  def self.up
    remove_column :profiles, :image
  end

  def self.down
    add_column :profiles, :image, :string
  end
end
