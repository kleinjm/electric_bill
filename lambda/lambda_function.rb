# frozen_string_literal: true

# Load gems
load_paths = Dir["/opt/vendor/bundle/ruby/2.6.0/gems/**/lib"]
$LOAD_PATH.unshift(*load_paths)

# Load custom library code
require "/opt/lib/xcel/client"

def lambda_handler(event:, context:)
  # validate_source!(event: event)

  XcelDownloader.new(
    xcel_username: ENV.fetch("XCEL_USERNAME"),
    xcel_password: ENV.fetch("XCEL_PASSWORD"),
    xcel_account_id: ENV.fetch("XCEL_ACCOUNT_ID")
  ).call
end

def validate_source!(event:)
  source = event.dig("Records", 0, "ses", "mail", "source")
  raise "Email source is not kleinjm007@gmail.com" if source != "kleinjm007@gmail.com"
end

class XcelDownloader
  def initialize(
    xcel_username:,
    xcel_password:,
    xcel_account_id:
  )
    @xcel_client = Xcel::Client.new
    @xcel_username = xcel_username
    @xcel_password = xcel_password
    @xcel_account_id = xcel_account_id

    @logger = Logger.new(STDOUT)
  end

  def call
    login_to_xcel
    # bill_path = download_latest_bill
  end

  def login_to_xcel
    logger.info("Logging into Xcel")
    xcel_client.login(username: xcel_username, password: xcel_password)
  end

  def download_latest_bill
    logger.info("Downloading latest Xcel bill")
    xcel_client.download_latest_bill(account_id: xcel_account_id)
  end
end
