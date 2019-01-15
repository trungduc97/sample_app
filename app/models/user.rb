class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  validates :email, presence: true,
                    length: {maximum: Settings.max_length_email},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :name,  presence: true, length: { maximum: Settings.max_length_name}
  validates :password, presence: true, length: { minimum: Settings.min_length_pass}
  
  has_secure_password

  private
  
  def email_downcase
    email.downcase!
  end

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end
  end
end
