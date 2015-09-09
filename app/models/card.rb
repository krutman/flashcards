class Card < ActiveRecord::Base
  before_validation :set_review_date, on: :create
  validates :original_text, presence: true, length: { maximum: 100 }
  validates :translated_text, presence: true, length: { maximum: 150 }
  validates :review_date, presence: true
  validate  :words_not_equal

  scope :by_creation_time, -> { order('created_at DESC')  }
  scope :availables_for_check, -> { where('review_date <= ?', Date.today) }
  #scope :random_available_card, -> { availables_for_check.order('RANDOM()').first if availables_for_check.present? }
  
  def self.random_available_card
    if availables_for_check.present?
      availables_for_check.order('RANDOM()').first
    else
      nil
    end
  end
  
  def correct_word?(word)
    self.original_text == word
  end
  
  def update_review_date
    self.update_attribute(:review_date, Date.today + 3.days)
  end
  
  private
  
    def words_not_equal
      if downcase_word(original_text) == downcase_word(translated_text)
        errors.add(:original_text, "should not be equal to translated text")
      end
    end
    
    def downcase_word(word)
      word.mb_chars.downcase.to_s if word.present?
    end
    
    def set_review_date
      self.review_date ||= Date.today + 3.days
    end
end
