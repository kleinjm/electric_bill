# frozen_string_literal: true

require "mechanize"

module Xcel
  class Login
    def initialize(username:, password:, account_id:)
      @agent = Mechanize.new
      @username = username
      @password = password
      @account_id = account_id
    end

    def call
      login_page = agent.get("https://myaccount.xcelenergy.com/oam/index.jsp")
      form = login_page.form("loginForm")
      form.j_username = username
      form.j_password = password

      agent.submit(form, form.buttons.first)
      bills_response = agent.get("https://myaccount.xcelenergy.com/oam/user/getMyBillsAccounts.req?account=#{account_id}")
      bills_json = JSON.parse(bills_response.body)
      latest_statement = bills_json.dig("statements", 0)

      bill_number = latest_statement["billNumber"]
      date = Date.parse(latest_statement["date"]).strftime("%Y-%m-%d")

      js_click_view = agent.get("https://myaccount.xcelenergy.com/oam/user/showpdf.req?isPopUp=true&stmtDate=#{date}&stmtNum=#{bill_number}")
      str1_markerstring = "window.location='"
      str2_markerstring = "'; "
      pdf_path = js_click_view.body[/#{str1_markerstring}(.*?)#{str2_markerstring}/m, 1]

      # TODO: fix bill download
      pdf = agent.download("https://myaccount.xcelenergy.com#{pdf_path}", Rails.root.join("bill.pdf"))
    end

    private

    attr_reader :username, :password, :agent, :account_id
  end
end
