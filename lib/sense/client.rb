# frozen_string_literal: true

require "sense/download_usage"
require "sense/login"

module Sense
  class Client
    def login(email:, password:)
      response = Sense::Login.new(email: email, password: password).call
      @auth_token = response[:auth_token]
      @monitor_id = response[:monitor_id]

      self
    end

    def download_usage(start_date:, end_date:)
      Sense::DownloadUsage.new(
        auth_token: auth_token, monitor_id: monitor_id,
        start_date: start_date, end_date: end_date
      ).call
    end

    private

    attr_reader :auth_token, :monitor_id
  end
end
