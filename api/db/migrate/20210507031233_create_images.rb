# Migration for creating the images table
class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table(:images) do |t|
      t.string(:title)
      t.text(:description)
      t.integer(:price)
      t.string(:state)
      t.string(:canvas_string)

      t.timestamps
    end
  end
end
