# frozen_string_literal: true

require "pdf-reader"

class ParseBillDateRange
  def initialize(bill_path:)
    @bill_path = bill_path
  end

  def call
    reader = PDF::Reader.new(bill_path)

    stats_row = reader.pages.first.text.split("\n").select do |row|
      row.match?(/Electricity Service/)
    end.first

    words = stats_row.split(" ")

    [Date.strptime(words[2], DATE_FORMAT), Date.strptime(words[4],DATE_FORMAT)]
  end

  private

  attr_reader :bill_path

  DATE_FORMAT = "%m/%d/%y"
  private_constant :DATE_FORMAT
end
