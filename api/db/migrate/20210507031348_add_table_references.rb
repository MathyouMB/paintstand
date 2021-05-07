# Migration for adding relation foreign keys to base tables
class AddTableReferences < ActiveRecord::Migration[6.0]
  def change
    add_reference(:images, :owner, index: true)
    add_reference(:images, :creator, index: true)

    add_reference(:image_tags, :image, foreign_key: true)
    add_reference(:image_tags, :tag, foreign_key: true)

    add_reference(:purchases, :image, foreign_key: true)
    add_reference(:purchases, :merchant, index: true)
    add_reference(:purchases, :customer, index: true)
  end
end
