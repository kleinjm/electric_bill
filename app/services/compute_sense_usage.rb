# frozen_string_literal: true

require "csv"

class ComputeSenseUsage
  def initialize(response_body:)
    @response_body = response_body
  end

  def call
    # shift to remove first row
    csv = response_body.split("\r")
    csv.shift
    csv.map!(&:strip)
    csv.reject!(&:blank?)

    parsed_csv = CSV.parse(csv.join("\n"), headers: true)

    parsed_csv.inject(0) do |res, row|
      res += row["kWh"].to_f
    end
  end

  private

  attr_reader :response_body
end
