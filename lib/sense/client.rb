# frozen_string_literal: true

require "sense/download_usage"
require "sense/login"

module Sense
  class Client
    def login(email:, password:)
      @auth_token = Sense::Login.new(email: email, password: password).call
      self
    end

    def download_usage(start_date:, end_date:)
      Sense::DownloadUsage.new(
        auth_token: auth_token, start_date: start_date, end_date: end_date
      ).call
    end

    private

    attr_reader :auth_token
  end
end
