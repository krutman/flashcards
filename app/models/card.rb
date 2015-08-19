class Card < ActiveRecord::Base
  validates :original_text, presence: true, length: { maximum: 30 }
  validates :translated_text, presence: true, length: { maximum: 30 }
  validates :review_date, presence: true
end
