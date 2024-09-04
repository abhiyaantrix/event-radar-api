# frozen_string_literal: true

require 'csv'

module CSVHelpers
  def generate_csv(csv_data)
    csv_string = CSV.generate do |csv|
      csv << csv_data.first if csv_data.any?
      csv_data.drop(1).inject(csv) { |acc, row| acc << row }
    end

    file = Tempfile.new
    file.write(csv_string)
    file.rewind
    file
  end
end
