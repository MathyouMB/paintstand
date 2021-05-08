# Represents a entity that has been purchased (likely an Image)
class Purchase < ApplicationRecord
  # IdentityCache
  include IdentityCache

  # Validations
  validates :cost, presence: true

  # Relations
  belongs_to :image
  belongs_to :merchant, class_name: "User", optional: true
  belongs_to :customer, class_name: "User", optional: true
end
