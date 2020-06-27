# frozen_string_literal: true

require "pdf-reader"

class ParseBill
  def call
    reader = PDF::Reader.new(Rails.root.join("tmp/last_bill.pdf"))
    reader.pages.first.text.split("\n").select { |row| row.match?(/Electricity Service/) }.first
  end
end

ParseBill.new.call
