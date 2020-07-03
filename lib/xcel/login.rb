# frozen_string_literal: true

require "mechanize"

module Xcel
  class Login
    def initialize(username:, password:)
      @agent = Mechanize.new
      @username = username
      @password = password
    end

    def call
      login_page = agent.get("https://myaccount.xcelenergy.com/oam/index.jsp")
      form = login_page.form("loginForm")
      form.j_username = username
      form.j_password = password

      agent.submit(form, form.buttons.first)
      agent
    end

    private

    attr_reader :username, :password, :agent
  end
end
