# frozen_string_literal: true

require "sense/client"
require "xcel/client"

class RunWorkflow
  def initialize(
    sense_email:,
    sense_password:,
    xcel_username:,
    xcel_password:,
    xcel_account_id:
  )
    @sense_client = Sense::Client.new
    @sense_email = sense_email
    @sense_password = sense_password

    @xcel_client = Xcel::Client.new
    @xcel_username = xcel_username
    @xcel_password = xcel_password
    @xcel_account_id = xcel_account_id
  end

  def call
    login_to_xcel
    bill = fetch_bill
    start_date, end_date = parse_bill_date_range(bill: bill)
    kwh_cost = compute_kwh_cost(bill: bill)

    login_to_sense
    response_body = download_sense_usage(start_date: start_date, end_date: end_date)
    total_kwh = compute_usage(response_body: response_body)

    usage_total = compute_usage_cost(kwh_used: total_kwh, kwh_cost: kwh_cost)

    # Cozy flow to bill tenants
  end

  private

  attr_reader(
    :sense_client,
    :sense_email,
    :sense_password,
    :xcel_account_id,
    :xcel_client,
    :xcel_password,
    :xcel_username
  )

  def login_to_xcel
    xcel_client.login(
      username: xcel_username,
      password: xcel_password,
      account_id: xcel_account_id
    )
  end

  def fetch_bill
    xcel_client.fetch_bill
  end

  def parse_bill_date_range(bill:)
    ParseBillDateRange.new(bill: bill).call
  end

  def compute_kwh_cost(bill:)
    ComputeKwhCost.new(bill: bill).call
  end

  def login_to_sense
    sense_client.login(email: sense_email, password: sense_password)
  end

  def download_sense_usage(start_date:, end_date:)
    sense_client.download_usage(start_date: start_date, end_date: end_date)
  end

  def compute_usage(response_body:)
    ComputeSenseUsage.new(response_body: response_body).call
  end

  def compute_usage_cost(kwh_used:, kwh_cost:)
    kwh_used * kwh_cost
  end
end

RunWorkflow.new(
  sense_email: ENV.fetch("SENSE_EMAIL"),
  sense_password: ENV.fetch("SENSE_PASSWORD"),
  xcel_username: ENV.fetch("XCEL_USERNAME"),
  xcel_password: ENV.fetch("XCEL_PASSWORD"),
  xcel_account_id: ENV.fetch("XCEL_ACCOUNT_ID")
).call
