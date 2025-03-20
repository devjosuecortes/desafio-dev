class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :validatable

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
