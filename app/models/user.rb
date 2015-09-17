class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  
  has_many :cards, dependent: :destroy
end
