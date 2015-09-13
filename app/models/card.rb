class Card < ActiveRecord::Base
  before_validation :set_review_date, on: :create
  default_scope -> { order('created_at DESC') }
  validates :original_text, presence: true, length: { maximum: 100 }
  validates :translated_text, presence: true, length: { maximum: 150 }
  validates :review_date, presence: true
  validate  :words_not_equal

  scope :for_review, -> { where('review_date <= ?', Date.today) }

  def self.random_for_review
    for_review.offset(rand(for_review.count))
  end

  def check_translation(text)
    if downcase_text(original_text) == downcase_text(text)
      update_attributes(review_date: Date.today + 3.days)
    end
  end
  
  private
  
    def words_not_equal
      if downcase_text(original_text) == downcase_text(translated_text)
        errors.add(:original_text, "should not be equal to translated text")
      end
    end
    
    def downcase_text(text)
      text.mb_chars.downcase.to_s.strip if text.present?
    end
    
    def set_review_date
      self.review_date ||= Date.today + 3.days
    end
end
