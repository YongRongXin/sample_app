class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  validates :name, presence: true, 
    length: { maximum: Settings.validations.name.max_length }

  validates :email, presence: true, 
    length: { maximum: Settings.validations.email.max_length },
    format: { with: Settings.validations.email.regex },
    uniqueness: true

  validates :password, presence: true, 
    length: { minimum: Settings.validations.password.min_length },
    allow_nil: true

  has_secure_password

  before_save :downcase_email
  before_create :create_activation_digest

  private
  def downcase_email
    email.downcase!
  end
 
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest remember_token
  end

  def authenticated? arttribute, token
    digest = send "#{arttribute}_digest"
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end
    
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
end
