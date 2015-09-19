class AddColumnAndIndexToUsers < ActiveRecord::Migration
  def change
    add_column :users, :salt, :string
    add_index :users, :email, unique: true
    rename_column :users, :password, :crypted_password
  end
end
