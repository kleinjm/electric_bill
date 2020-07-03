# frozen_string_literal: true

require "pdf-reader"

class ComputeKwhCost
  def initialize(bill_path:)
    @bill_path = bill_path
  end

  def call
    reader = PDF::Reader.new(bill_path)

    stats_row = reader.pages.first.text.split("\n").select do |row|
      row.match?(/Electricity Service/)
    end.first

    words = stats_row.split(" ")
    kwh = words[5].to_f
    cost = words[7].gsub("$", "").to_f

    (cost / kwh).round(2)
  end

  private

  attr_reader :bill_path
end
