class RemoveUserIdFromCards < ActiveRecord::Migration
  def change
    remove_column :cards, :user_id
  end
end
