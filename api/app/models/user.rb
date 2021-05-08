# This Model represents a User entity
class User < ApplicationRecord
  # IdentityCache
  include IdentityCache

  # Bcrypt Secure Password
  has_secure_password

  # Validations
  validates :balance, presence: true
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: ["public", "admin"] }

  # Relations
  has_many :created_images, class_name: "Image", foreign_key: "creator_id", dependent: :delete_all, inverse_of: :creator
  has_many :owned_images, class_name: "Image", foreign_key: "owner_id", dependent: :delete_all, inverse_of: :owner
  has_many :purchases, class_name: "Purchase", foreign_key: "customer_id", dependent: :delete_all, inverse_of: :customer
  has_many :sales, class_name: "Purchase", foreign_key: "merchant_id", dependent: :delete_all, inverse_of: :merchant
end
