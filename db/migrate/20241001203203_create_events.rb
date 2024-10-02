# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.2]

  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time # null allowed for open ended events

      t.timestamps

      t.index :start_time
    end

    add_check_constraint :events, "end_time IS NULL OR end_time > start_time"
  end

end
