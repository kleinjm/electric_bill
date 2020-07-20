# frozen_string_literal: true

module Sense
  class Login
    require "net/http"
    require "uri"

    def initialize(email:, password:)
      @email = email
      @password = password
    end

    # returns access token for authorized requests
    def call
      uri = URI("https://api.sense.com/apiservice/api/v1/authenticate")
      response = Net::HTTP.post_form(uri, "email" => email, 'password' => password)
      raise "Login failure" unless response.code == "200"

      body = JSON.parse(response.body)
      raise "Unauthorized" unless body["authorized"]

      {
        auth_token: body["access_token"],
        monitor_id: body.dig("monitors", 0, "id")
      }
    end

    private

    attr_reader :email, :password
  end
end
