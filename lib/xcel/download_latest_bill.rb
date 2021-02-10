# frozen_string_literal: true

module Xcel
  class DownloadLatestBill
    class LocalDownloader
      def initialize(pdf_url:, browser:)
        @pdf_url = pdf_url
        @browser = browser
      end

      def call
        pdf_file_path = Rails.root.join("tmp/latest_bill.pdf")

        # TODO: get the browser download working
        require "pry"; binding.pry

        File.open(pdf_file_path, 'wb') do |file|
          file << browser.goto(pdf_url)
        end

        pdf_file_path
      end

      private

      attr_reader :pdf_url, :browser
    end

    def initialize(account_id:, browser:, downloader: LocalDownloader)
      @account_id = account_id
      @browser = browser
      @downloader = downloader
    end

    def call
      downloader.new(pdf_url: pdf_path, browser: browser).call
    end

    private

    attr_reader :account_id, :browser, :downloader

    def pdf_path
      # need to pause before navigating again
      browser.h2(text: "Bill Summary").wait_until(&:present?)
      browser.goto("https://myaccount.xcelenergy.com/oam/user/currentebill.req")
      browser.table(data_ui: "billHistoryTable").tr(class: "bill-history-row").td(class: "buttonContainerUpd").a.attribute("href")
    end
  end
end
