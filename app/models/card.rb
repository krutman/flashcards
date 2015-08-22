class Card < ActiveRecord::Base
  after_initialize :set_review_date
  default_scope -> { order('created_at DESC') }
  validates :original_text, presence: true, length: { maximum: 30 }
  validates :translated_text, presence: true, length: { maximum: 30 }
  validates :review_date, presence: true
  validate  :words_not_equal
  
  private
  
    def words_not_equal
      if downcase_word(original_text) == downcase_word(translated_text)
        errors.add(:original_text, "should not be equal to translated text")
      end
    end
    
    def downcase_word(word)
      word.mb_chars.downcase.to_s
    end
    
    def set_review_date
      self.review_date = Date.current + 3 if self.new_record?
    end
end
