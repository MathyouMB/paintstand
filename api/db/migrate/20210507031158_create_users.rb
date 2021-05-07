# Migration for the Users table
class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table(:users) do |t|
      t.string(:email)
      t.string(:username)
      t.integer(:balance)
      t.string(:role)
      t.string(:password_digest)

      t.timestamps
    end
    add_index(:users, :email, unique: true)
    add_index(:users, :username, unique: true)
  end
end
