# frozen_string_literal: true

module Xcel
  class DownloadLatestBill
    def initialize(browser:)
      @browser = browser
      @downloader = downloader
    end

    def call
      navigate_to_bill
    end

    private

    attr_reader :browser, :downloader

    def navigate_to_bill
      # need to pause before navigating again
      browser.h2(text: "Bill Summary").wait_until(&:present?)
      browser.goto("https://myaccount.xcelenergy.com/oam/user/currentebill.req")

      puts "Download bill to tmp/latest_bill.pdf and hit any key to continue"
      gets.chomp
    end
  end
end
