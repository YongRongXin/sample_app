class User < ApplicationRecord
  validates :name, presence: true, 
    length: { maximum: Settings.validations.name.max_length }

  validates :email, presence: true, 
    length: { maximum: Settings.validations.email.max_length },
    format: ( with: VALID_EMAIL_REGEX )
    uniqueness: ( case_sensitive: false )

  validates :password, presence: true, 
    length: { minimum: Settings.validations.password.min_length }

  has_secure_password

  before_save :downcase_email

  def downcase_email
    email.downcase!
  end
end