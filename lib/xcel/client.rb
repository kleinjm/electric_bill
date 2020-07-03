# frozen_string_literal: true

require "xcel/download_latest_bill"
require "xcel/login"

module Xcel
  class Client
    def login(username:, password:)
      @agent = Xcel::Login.new(
        username: username, password: password
      ).call
      self
    end

    def download_latest_bill(account_id:)
      raise "Not logged into Xcel" if agent.blank?

      Xcel::DownloadLatestBill.new(account_id: account_id, agent: agent).call
    end

    private

    attr_reader :agent
  end
end
