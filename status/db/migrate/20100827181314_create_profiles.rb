class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string :name
      t.string :profession
      t.string :company
      t.string :image
      t.text :about
      t.integer :user_id
      t.integer :private_address_id
      t.integer :business_address_id

      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
