class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :cards, dependent: :destroy
  attr_accessor :current
  after_save :set_current_deck
  validates :title, presence: true
  validates :user_id, presence: true
  
  private
  
    def set_current_deck
      if current == '1'
        user.update_attributes(current_deck_id: id)
      else
        user.update_attributes(current_deck_id: nil)
      end
    end
end
