# frozen_string_literal: true

# require "xcel/fetch_latest_bill"
require "xcel/login"

module Xcel
  class Client
    def login(username:, password:, account_id:)
      Xcel::Login.new(username: username, password: password, account_id: account_id).call
    end

    def fetch_latest_bill
      # Xcel::FetchLatestBill.new.call
    end
  end
end
