class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # This maps 0 -> farmer, 1 -> admin
  enum :role, { farmer: 0, admin: 1 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
