# frozen_string_literal: true

class AddStatusToEvents < ActiveRecord::Migration[7.2]

  def change
    add_column :events, :status, :integer, limit: 2, default: 0, null: false
  end

end
