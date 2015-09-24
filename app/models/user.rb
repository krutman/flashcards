class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessor :current_password
  before_save :downcase_email
  before_validation :check_current_password, on: :update, if: :current_password_required?
  before_save :reset_activation_if_email_changed, on: :update
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
  validates :password, length: { minimum: 6 }, if: :password_required?
  validates :password, confirmation: true
  validates :password_confirmation, presence: true, if: :password_required?

  has_many :cards, dependent: :destroy
  
  private
  
    def downcase_email
      self.email = email.downcase
    end
    
    def check_current_password
      unless BCrypt::Password.new(self.crypted_password_was) == (self.current_password + self.salt_was)
        errors.add(:current_password, "is wrong")
      end
    end
    
    def reset_activation_if_email_changed
      if self.email_was != self.email
        self.activation_state = "pending"
        self.activation_token = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
        UserMailer.activation_needed_email(self).deliver_now
      end
    end
    
    def current_password_required?
      !new_record? && (password.present? || password_confirmation.present?)
    end
    
    def password_required?
      new_record? || current_password.present?
    end
end
