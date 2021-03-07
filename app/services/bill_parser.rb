# frozen_string_literal: true

class BillParser
  def initialize(bill_text:, logger: nil)
    @bill_text = bill_text
    @bill = Bill.new
    @logger = logger || Logger.new(STDOUT)
  end

  def call
    parse_electric
    parse_gas
    bill
  end

  private

  attr_reader :bill_text, :bill, :logger

  DATE_FORMAT = "%m/%d/%y"
  ELECTRIC_ROW = Regexp.new(/Electricity Service/)
  GAS_ROW = Regexp.new(/Natural Gas Service/)
  private_constant :DATE_FORMAT, :ELECTRIC_ROW, :GAS_ROW

  def parse_electric
    logger.info("Parsing bill electric")

    electric_row = bill_text.select { |row| row.match?(ELECTRIC_ROW) }.first
    words = electric_row.split(" ")

    bill.start_date = Date.strptime(words[2], DATE_FORMAT)
    bill.end_date = Date.strptime(words[4],DATE_FORMAT)

    bill.total_kwh = words[5].to_f
    bill.total_electric_cost = words[7].gsub("$", "").to_f
  end

  def parse_gas
    logger.info("Parsing bill gas")

    gas_row = bill_text.select { |row| row.match?(GAS_ROW) }.first
    words = gas_row.split(" ")

    bill.total_gas_cost = words.last.gsub("$", "").to_f
  end
end
