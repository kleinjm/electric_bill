# frozen_string_literal: true

module Xcel
  class DownloadLatestBill
    class LocalDownloader
      def initialize(pdf_url:, browser:)
        @pdf_url = pdf_url
        @browser = browser
      end

      def call
        image_path = Rails.root.join("tmp/latest_bill.png")
        ocr_output_path = Rails.root.join("tmp/latest_bill")

        browser.goto(pdf_url)
        browser.screenshot.save(image_path)

        # tesseract is installed via brew. The gem doesn't work so call via cli
        `tesseract #{image_path} #{ocr_output_path} -l eng`
        file = File.open("#{ocr_output_path}.txt")

        file.each_with_object([]) { |line, output| output << line }
      end

      private

      attr_reader :pdf_url, :browser
    end

    def initialize(browser:, downloader: LocalDownloader)
      @browser = browser
      @downloader = downloader
    end

    def call
      downloader.new(pdf_url: pdf_path, browser: browser).call
    end

    private

    attr_reader :browser, :downloader

    def pdf_path
      # need to pause before navigating again
      browser.h2(text: "Bill Summary").wait_until(&:present?)
      browser.goto("https://myaccount.xcelenergy.com/oam/user/currentebill.req")
      browser.
        table(data_ui: "billHistoryTable").
        tr(class: "bill-history-row").
        td(class: "buttonContainerUpd").
        a.attribute("href")
    end
  end
end
