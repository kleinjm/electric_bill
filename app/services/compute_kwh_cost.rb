# frozen_string_literal: true

class ComputeKwhCost
  def initialize(bill_text:, logger: Rails.logger)
    @bill_text = bill_text
    @logger = logger
  end

  def call
    stats_row = bill_text.select do |row|
      row.match?(/Electricity Service/)
    end.first

    words = stats_row.split(" ")
    kwh = words[5].to_f
    cost = words[7].gsub("$", "").to_f
    logger.info("Bill totals: #{kwh} kwh, $#{cost}")

    (cost / kwh).round(4) # go to 4 decimal places because it adds up
  end

  private

  attr_reader :bill_text, :logger
end
