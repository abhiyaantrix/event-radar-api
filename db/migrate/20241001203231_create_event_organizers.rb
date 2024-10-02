# frozen_string_literal: true

class CreateEventOrganizers < ActiveRecord::Migration[7.2]

  def change
    create_table :event_organizers do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps

      t.index [ :user_id, :event_id ], unique: true
    end
  end

end
