class User < ApplicationRecord
  validates :name, presence: true, 
    length: { maximum: Settings.validations.name.max_length }

  validates :email, presence: true, 
    length: { maximum: Settings.validations.email.max_length },
    format: { with: Settings.validations.email.regex },
    uniqueness: true

  validates :password, presence: true, 
    length: { minimum: Settings.validations.password.min_length }

  has_secure_password

  before_save :downcase_email

  def downcase_email
    email.downcase!
  end
end