# Join Model between Image and Tag
class ImageTag < ApplicationRecord
  # IdentityCache
  include IdentityCache

  # Relations
  belongs_to :image
  belongs_to :tag
end
