# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem "bootsnap", ">= 1.1.0", require: false
gem "foreman"
gem "jbuilder", "~> 2.5"
gem "mechanize"
gem "nokogiri"
gem "pdf-reader"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.11"
gem "rails", "~> 7.0.0"
gem "sass-rails", "~> 5.0"
gem "sidekiq"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"
gem "watir"
gem "webdrivers"

group :development, :test do
  gem "pry-rails"
end

group :development do
  gem "spring"
end
