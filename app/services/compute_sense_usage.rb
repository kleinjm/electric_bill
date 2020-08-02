# frozen_string_literal: true

require "csv"

class ComputeSenseUsage
  def initialize(response_body:)
    @response_body = response_body
  end

  def call
    csv_data = format_csv_data
    File.write("tmp/sense_usage.csv", csv_data)
    parsed_csv = CSV.parse(csv_data, headers: true)

    validate_data_exists!(parsed_csv: parsed_csv)

    parsed_csv.inject(0) do |res, row|
      next res unless row["Name"] == "Total Usage" # only care about the total usage
      validate_row_data!(row: row)

      res += row["kWh"].to_f
    end
  end

  private

  attr_reader :response_body

  def format_csv_data
    # shift to remove first row
    csv = response_body.split("\r")
    csv.shift
    csv.map!(&:strip)
    csv.reject!(&:blank?)
    csv.join("\n")
  end

  def validate_row_data!(row:)
    raise "Missing kwh value for row: #{row}" unless row["kWh"].present?
  end

  def validate_data_exists!(parsed_csv:)
    return true if parsed_csv.count.positive?

    raise HandledError, "Sense usage CSV has no data"
  end
end
