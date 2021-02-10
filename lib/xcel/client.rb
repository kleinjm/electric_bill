# frozen_string_literal: true

require_relative "./download_latest_bill"
require_relative "./login"

module Xcel
  class Client
    def login(username:, password:)
      @browser = Xcel::Login.new(
        username: username, password: password
      ).call
      self
    end

    def download_latest_bill(account_id:)
      raise "Not logged into Xcel" if browser.blank?

      Xcel::DownloadLatestBill.new(account_id: account_id, browser: browser).call
    end

    private

    attr_reader :browser
  end
end
