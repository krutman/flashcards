class Card < ActiveRecord::Base
  default_scope -> { order('created_at DESC') }
  validates :original_text, presence: true, length: { maximum: 30 }
  validates :translated_text, presence: true, length: { maximum: 30 }
  VALID_DATE_REGEX = /\A(20[0-9][0-9])\-(0[1-9]|1[0-2])\-(0[1-9]|[1-2][0-9]|3[0-1])\z/
  validates :review_date, presence: true, format: { with: VALID_DATE_REGEX }
  validate  :not_equal
  
  private
  
    def not_equal
      if original_text.mb_chars.downcase.to_s == translated_text.mb_chars.downcase.to_s
        errors.add(:original_text, "should not be equal to translated text")
      end
    end
end
