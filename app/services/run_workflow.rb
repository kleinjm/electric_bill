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
    download_latest_bill

    bill_path = Rails.root.join("tmp", "latest_bill.pdf")
    bill = parse_bill(bill_path: bill_path)

    calculate_usage(unit: :main, bill: bill)
    calculate_usage(unit: :basement, bill: bill)

    bill.print
    `open https://home.cozy.co/app/#!/properties/`
    logger.info("Workflow completed successfully!")
    # TODO: Cozy flow to bill tenants
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
    login_to_xcel
    logger.info("Downloading latest Xcel bill")
    xcel_client.download_latest_bill
  end

  def parse_bill(bill_path:)
    logger.info("Parsing bill")
    BillParser.new(bill_path: bill_path, logger: logger).call
  end

  def calculate_usage(unit:, bill:)
    case unit
    when :main
      login_to_sense(email: main_sense_email)
      response_body = download_sense_usage(bill: bill)
      total_kwh = compute_usage(response_body: response_body)

      bill.main_electric_cost = compute_usage_cost(
        kwh_used: total_kwh, kwh_cost: bill.kwh_cost
      )
    when :basement
      login_to_sense(email: basement_sense_email)
      response_body = download_sense_usage(bill: bill)
      total_kwh = compute_usage(response_body: response_body)

      bill.basement_electric_cost = compute_usage_cost(
        kwh_used: total_kwh, kwh_cost: bill.kwh_cost
      )
    end
  end

  def login_to_sense(email:)
    logger.info("Logging into Sense for #{email}")
    sense_client.login(email: email, password: sense_password)
  end

  def download_sense_usage(bill:)
    logger.info("Downloading Sense usage data from #{bill.start_date} to #{bill.end_date}")
    sense_client.download_usage(start_date: bill.start_date, end_date: bill.end_date)
  end

  def compute_usage(response_body:)
    logger.info("Computing total sense usage")
    ComputeSenseUsage.new(response_body: response_body).call
  end

  def compute_usage_cost(kwh_used:, kwh_cost:)
    logger.info("Computing total usage cost")
    logger.info("kWh used: #{kwh_used}")
    total_cost = (kwh_used * kwh_cost).round(2)
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
