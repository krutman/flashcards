class AddCoverToCards < ActiveRecord::Migration
  def change
    add_column :cards, :cover, :string
  end
end
