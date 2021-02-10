# frozen_string_literal: true

class ParseBillDateRange
  def initialize(bill_text:)
    @bill_text = bill_text
  end

  def call
    stats_row = bill_text.select do |row|
      row.match?(/Electricity Service/)
    end.first

    words = stats_row.split(" ")

    [Date.strptime(words[2], DATE_FORMAT), Date.strptime(words[4],DATE_FORMAT)]
  end

  private

  attr_reader :bill_text

  DATE_FORMAT = "%m/%d/%y"
  private_constant :DATE_FORMAT
end
