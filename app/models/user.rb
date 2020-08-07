class User < ApplicationRecord
  USERS_PARAMS = %i(name email password password_confirmation).freeze

  validates :name,
            presence: true,
            length: {maximum: Settings.validate.user.max_length_name}
  validates :email,
            presence: true,
            length: {maximum: Settings.validate.user.max_length_email},
            format: {with: Settings.validate.user.validate_email_regex},
            uniqueness: true
  validates :password,
            presence: true,
            length: {minimum: Settings.validate.user.min_length_password}

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end
  end

  before_save :downcase_email

  private
  def downcase_email
    email.downcase!
  end
end
