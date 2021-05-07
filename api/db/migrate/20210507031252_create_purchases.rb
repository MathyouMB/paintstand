# Migration for creating the purchases table
class CreatePurchases < ActiveRecord::Migration[6.0]
  def change
    create_table(:purchases) do |t|
      t.integer(:cost)

      t.timestamps
    end
  end
end
