# Represents the Tag entity
class Tag < ApplicationRecord
  # IdentityCache
  include IdentityCache

  # Validations
  validates :name, presence: true, uniqueness: true

  # Relations
  has_many :image_tags, dependent: :delete_all
  has_many :images, through: :image_tags
end
