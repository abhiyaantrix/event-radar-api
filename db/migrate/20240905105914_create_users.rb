# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.2]

  disable_ddl_transaction!

  def change
    safety_assured do
      create_table :users do |t|
        t.string :email, null: false
        t.string :first_name, null: false
        t.string :last_name, null: false
        t.virtual :full_name, type: :string, as: "TRIM(first_name) || ' ' || TRIM(last_name)", stored: true
        t.integer :status, limit: 2, null: false, default: 0
        t.text :archival_reason
        t.jsonb :preferences, default: {}

        t.timestamps

        t.index :email, unique: true, algorithm: :concurrently
      end

      add_index :users, 'LOWER(email)', name: 'index_users_on_email_lower', algorithm: :concurrently

      add_index :users, 'LOWER(full_name)', name: 'index_users_on_full_name_lower', algorithm: :concurrently
    end
  end

end
