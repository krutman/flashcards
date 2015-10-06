class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :cards, dependent: :destroy
  before_save :reset_other_current_deck, if: -> { current? }
  validates :title, presence: true
  validates :user_id, presence: true
  
  private
  
    def reset_other_current_deck
      user.decks.where(current: true).each do |deck|
        deck.update_attributes(current: false)
      end
    end
end
