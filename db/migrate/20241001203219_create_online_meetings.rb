# frozen_string_literal: true

class CreateOnlineMeetings < ActiveRecord::Migration[7.2]

  def change
    create_table :online_meetings do |t|
      t.string :title, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time # null allowed for open ended events

      t.references :event, null: false, foreign_key: true

      t.timestamps

      t.index :start_time
    end

    add_check_constraint :online_meetings, "end_time IS NULL OR end_time > start_time"
  end

end
