class SorceryExternal < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider, :uid, null: false
      t.belongs_to :user, index: true, foreign_key: true, null: false
      
      t.timestamps
    end

    add_index :authentications, [:provider, :uid], unique: true
  end
end
