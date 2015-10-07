class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string :title
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
