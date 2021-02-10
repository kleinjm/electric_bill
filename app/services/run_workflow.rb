# frozen_string_literal: true

require "sense/client"
require "xcel/client"

class RunWorkflow
  def initialize(
    main_sense_email:,
    basement_sense_email:,
    sense_password:,
    xcel_username:,
    xcel_password:
  )
    @sense_client = Sense::Client.new
    @main_sense_email = main_sense_email
    @basement_sense_email = basement_sense_email
    @sense_password = sense_password

    @xcel_client = Xcel::Client.new
    @xcel_username = xcel_username
    @xcel_password = xcel_password

    @logger = Logger.new(STDOUT)
  end

  def call
    login_to_xcel
    bill_text = download_latest_bill
    start_date, end_date = parse_bill_date_range(bill_text: bill_text)
    kwh_cost = compute_kwh_cost(bill_text: bill_text)

    [main_sense_email, basement_sense_email].each do |email|
      login_to_sense(email: email)
      response_body = download_sense_usage(start_date: start_date, end_date: end_date)
      total_kwh = compute_usage(response_body: response_body)

      usage_total = compute_usage_cost(kwh_used: total_kwh, kwh_cost: kwh_cost)
    end

    # TODO: Cozy flow to bill tenants
    logger.info("Workflow completed successfully!")
  rescue HandledError => e
    logger.error(e.inspect)
  end

  private

  attr_reader(
    :logger,
    :sense_client,
    :basement_sense_email,
    :main_sense_email,
    :sense_password,
    :xcel_client,
    :xcel_password,
    :xcel_username
  )

  def login_to_xcel
    logger.info("Logging into Xcel")
    xcel_client.login(username: xcel_username, password: xcel_password)
  end

  def download_latest_bill
    logger.info("Downloading latest Xcel bill")
    xcel_client.download_latest_bill
  end

  def parse_bill_date_range(bill_text:)
    logger.info("Parsing bill date range")
    ParseBillDateRange.new(bill_text: bill_text).call
  end

  def compute_kwh_cost(bill_text:)
    logger.info("Computing kwh cost")
    kwh_cost = ComputeKwhCost.new(bill_text: bill_text, logger: logger).call

    logger.info("kWh cost: $#{kwh_cost}")
    kwh_cost
  end

  def login_to_sense(email:)
    logger.info("Logging into Sense for #{email}")
    sense_client.login(email: email, password: sense_password)
  end

  def download_sense_usage(start_date:, end_date:)
    logger.info("Downloading Sense usage data from #{start_date} to #{end_date}")
    sense_client.download_usage(start_date: start_date, end_date: end_date)
  end

  def compute_usage(response_body:)
    logger.info("Computing total sense usage")
    ComputeSenseUsage.new(response_body: response_body).call
  end

  def compute_usage_cost(kwh_used:, kwh_cost:)
    logger.info("Computing total usage cost")
    logger.info("kWh used: #{kwh_used}")
    total_cost = (kwh_used * kwh_cost).round(2)

    logger.info("Total cost: #{total_cost}")
    total_cost
  end
end

RunWorkflow.new(
  main_sense_email: ENV.fetch("MAIN_SENSE_EMAIL"),
  basement_sense_email: ENV.fetch("BASEMENT_SENSE_EMAIL"),
  sense_password: ENV.fetch("SENSE_PASSWORD"),
  xcel_username: ENV.fetch("XCEL_USERNAME"),
  xcel_password: ENV.fetch("XCEL_PASSWORD")
).call
