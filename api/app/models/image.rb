# Represents the Image entity and its associated data
class Image < ApplicationRecord
  # IdentityCache
  include IdentityCache

  # Scope
  scope :listed_images, -> { where(state: "listed") }
  scope :public_images, -> { where(state: ("private" || "listed")) }

  # Validations
  validates :title, presence: true
  validates :price, presence: true
  validates :state, presence: true, inclusion: { in: ["private", "public", "listed"] }

  # Relations
  belongs_to :creator, class_name: "User", optional: false
  cache_belongs_to :creator
  belongs_to :owner, class_name: "User", optional: false
  cache_belongs_to :owner
  has_many :image_tags, dependent: :delete_all
  has_many :tags, through: :image_tags
  has_many :purchases, dependent: :delete_all

  # Active Storage
  has_one_attached :attached_image

  # Methods
  def attached_image_url
    Rails.cache.fetch([cache_key, __method__]) do
      Rails.application.routes.url_helpers
        .rails_blob_url(attached_image, only_path: true)
    end
  end

  def search_string
    Rails.cache.fetch([cache_key, __method__]) do
      s = title + " " + description + " "
      s + tags.map(&:name).join(", ")
    end
  end
end
