# frozen_string_literal: true

module Sense
  class DownloadUsage
    require 'net/http'
    require 'uri'

    def initialize(auth_token:, start_date:, end_date:)
      @auth_token = auth_token
      @end_date = end_date.strftime(DATE_FORMAT)
      @start_date = start_date.strftime(DATE_FORMAT)
    end

    def call
      uri = URI.parse("https://api.sense.com/apiservice/api/v1/monitors/192953/data?start=#{start_date}T06%3A00%3A00.000Z&end=#{end_date}T06%3A00%3A00.000Z&time_unit=DAY")
      request = Net::HTTP::Get.new(uri)
      request.content_type = "application/x-www-form-urlencoded; charset=UTF-8;"
      request["Connection"] = "keep-alive"
      request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36"
      request["X-Sense-Protocol"] = "3"
      request["Authorization"] = "bearer #{auth_token}"
      request["Accept"] = "*/*"
      request["Origin"] = "https://home.sense.com"
      request["Sec-Fetch-Site"] = "same-site"
      request["Sec-Fetch-Mode"] = "cors"
      request["Sec-Fetch-Dest"] = "empty"
      request["Referer"] = "https://home.sense.com/trends"
      request["Accept-Language"] = "en-US,en;q=0.9"

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      raise "Error fetching usage" unless response.code == "200"

      response.body
    end

    private

    DATE_FORMAT = "%Y-%m-%d"
    private_constant :DATE_FORMAT

    attr_reader :auth_token, :start_date, :end_date
  end
end
