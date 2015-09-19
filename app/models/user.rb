class User < ActiveRecord::Base
  authenticates_with_sorcery!
  before_save :downcase_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
  validates :password, length: { minimum: 6 }, presence: true, if: -> { new_record? || !changes["email"] }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true, if: -> { new_record? || !changes["email"] }
  
  has_many :cards, dependent: :destroy
  
  private
  
    def downcase_email
      self.email = email.downcase if self.email.present?
    end
end
