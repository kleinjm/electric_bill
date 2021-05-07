# frozen_string_literal: true

require "pdf-reader"

class BillParser
  def initialize(bill_path:, logger: nil)
    @bill_path = bill_path
    @bill = Bill.new
    @logger = logger || Logger.new(STDOUT)
    @reader = PDF::Reader.new(bill_path)
  end

  def call
    parse_electric
    parse_gas
    bill
  end

  private

  attr_reader :bill_path, :bill, :logger, :reader

  DATE_FORMAT = "%m/%d/%y"
  ELECTRIC_ROW = Regexp.new(/Electricity Service/)
  GAS_ROW = Regexp.new(/Natural Gas Service/)
  private_constant :DATE_FORMAT, :ELECTRIC_ROW, :GAS_ROW

  def parse_electric
    logger.info("Parsing bill electric")

    electric_row = reader.pages.first.text.split("\n").select do |row|
      row.match?(ELECTRIC_ROW)
    end.first

    words = electric_row.split(" ")

    bill.start_date = Date.strptime(words[2], DATE_FORMAT)
    bill.end_date = Date.strptime(words[4],DATE_FORMAT)

    bill.total_kwh = words[5].to_f
    bill.total_electric_cost = words[7].gsub("$", "").to_f
  end

  def parse_gas
    logger.info("Parsing bill gas")

    gas_row = reader.pages.first.text.split("\n").select do |row|
      row.match?(GAS_ROW)
    end.first

    words = gas_row.split(" ")

    bill.total_gas_cost = words.last.gsub("$", "").to_f
  end
end
