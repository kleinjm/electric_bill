# frozen_string_literal: true

class FetchUsage
  DATE_FORMAT = "%Y-%m-%d"

  def call(start_date:, end_date:)
    require 'net/http'
    require 'uri'
    require "csv"

    start_date = start_date.strftime(DATE_FORMAT)
    end_date = end_date.strftime(DATE_FORMAT)

    uri = URI.parse("https://api.sense.com/apiservice/api/v1/monitors/192953/data?start=#{start_date}T06%3A00%3A00.000Z&end=#{end_date}T06%3A00%3A00.000Z&time_unit=DAY")
    request = Net::HTTP::Get.new(uri)
    request.content_type = "application/x-www-form-urlencoded; charset=UTF-8;"
    request["Connection"] = "keep-alive"
    request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36"
    request["X-Sense-Protocol"] = "3"
    request["Authorization"] = "bearer t1.v2.eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJTZW5zZSBJbmMiLCJleHAiOjE1OTM0Nzc2NjMsInVzZXJJZCI6NTY0MTIsImFjY291bnRJZCI6NTU5NzAsInJvbGVzIjoidXNlciIsImRoYXNoIjoiMGIxMTcifQ.D-nIj4zV0VXAhsf1v3mk64w-emnUlXGPtk4xMxcA-nTdziVY75JUy8Im5C8E2PLluDFMGZ_UoJotWxHW8fk12Q"
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

    # shift to remove first row
    csv = response.body.split("\r")
    csv.shift
    csv.map!(&:strip)
    csv.reject!(&:blank?)

    parsed_csv = CSV.parse(csv.join("\n"), headers: true)

    # TODO: account for given date range
    total_usage = parsed_csv.inject(0) do |res, row|
      res += row["kWh"].to_f
    end
  end
end

usage = FetchUsage.new.call(start_date: Time.current.localtime.to_date, end_date: 2.days.from_now.localtime.to_date)
