class Card < ActiveRecord::Base
  after_initialize :set_review_date
  default_scope -> { order('created_at DESC') }
  validates :original_text, presence: true, length: { maximum: 30 }
  validates :translated_text, presence: true, length: { maximum: 30 }
  validates :review_date, presence: true
  validate  :words_not_equal
  
  private
  
    def words_not_equal
      if original_text.mb_chars.downcase.to_s == translated_text.mb_chars.downcase.to_s
        errors.add(:original_text, "should not be equal to translated text")
      end
    end
    
    def set_review_date
      if self.new_record?
        self.review_date = (Date.current + 3).strftime('%d-%m-%Y')
      else
        self.review_date = self.review_date.strftime('%d-%m-%Y')
      end
    end
end
