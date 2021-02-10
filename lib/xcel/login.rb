# frozen_string_literal: true

require "watir"

module Xcel
  class Login
    def initialize(username:, password:)
      @username = username
      @password = password
    end

    def call
      browser = Watir::Browser.start("https://my.xcelenergy.com/MyAccount/XE_Login?template=XE_MA_Template")
      browser.text_field(id: "gigya-loginID-18682410354408050").set(username)
      browser.text_field(id: "gigya-password-77105095086979630").set(password)
      browser.input(value: "Sign In").click
      browser
    end

    private

    attr_reader :username, :password
  end
end
