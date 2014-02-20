class AddLoginTokenToUsers < ActiveRecord::Migration
  def change

    add_column :users, :login_token, :string
    add_column :users, :login_token_date, :datetime

  end
end
