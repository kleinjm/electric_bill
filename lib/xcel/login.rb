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
      require 'watir'
      require 'webdrivers'
      browser = Watir::Browser.new
      browser.goto 'https://my.xcelenergy.com/MyAccount/XE_Login?template=XE_MA_Template'

      # login_page = agent.get("https://my.xcelenergy.com/MyAccount/XE_Login?template=XE_MA_Template")
      require "pry"; binding.pry
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
