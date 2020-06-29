# frozen_string_literal: true

require "pdf-reader"

class ParseBill
  def call
    reader = PDF::Reader.new(Rails.root.join("tmp/last_bill.pdf"))
    stats_row = reader.pages.first.text.split("\n").select { |row| row.match?(/Electricity Service/) }.first
    words = stats_row.split(" ")
    kwh = words[5].to_f
    cost = words[7].gsub("$", "").to_f

    (cost / kwh).round(2)
  end
end
