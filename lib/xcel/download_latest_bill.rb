# frozen_string_literal: true

module Xcel
  class DownloadLatestBill
    class LocalDownloader
      def initialize(pdf_url:, agent:)
        @pdf_url = pdf_url
        @agent = agent
      end

      def call
        pdf_file_path = Rails.root.join("tmp/latest_bill.pdf")

        File.open(pdf_file_path, 'wb') do |file|
          file << agent.get(pdf_url).body
        end

        pdf_file_path
      end

      private

      attr_reader :pdf_url, :agent
    end

    def initialize(account_id:, agent:, downloader: LocalDownloader)
      @account_id = account_id
      @agent = agent
      @downloader = downloader
    end

    def call
      bills_list_json = fetch_bill_list

      latest_statement = bills_list_json.dig("statements", 0)
      bill_number = latest_statement["billNumber"]
      date = Date.parse(latest_statement["date"]).strftime("%Y-%m-%d")

      pdf_path = fetch_pdf_link(date: date, bill_number: bill_number)

      download_pdf(pdf_path: pdf_path)
    end

    private

    attr_reader :account_id, :agent, :downloader

    def fetch_bill_list
      bills_response = agent.get(
        "https://myaccount.xcelenergy.com/oam/user/getMyBillsAccounts.req" \
        "?account=#{account_id}"
      )
      JSON.parse(bills_response.body)
    end

    def fetch_pdf_link(date:, bill_number:)
      js_click_view = agent.get(
        "https://myaccount.xcelenergy.com/oam/user/showpdf.req?" \
        "isPopUp=true&stmtDate=#{date}&stmtNum=#{bill_number}"
      )
      str1_markerstring = "window.location='"
      str2_markerstring = "'; "
      js_click_view.body[/#{str1_markerstring}(.*?)#{str2_markerstring}/m, 1]
    end

    def download_pdf(pdf_path:)
      full_path = "https://myaccount.xcelenergy.com#{pdf_path}"
      downloader.new(pdf_url: full_path, agent: agent).call
    end
  end
end
