# frozen_string_literal: true

source "https://rubygems.org"

gem "sinatra"
gem "rackup"
gem "faraday"

group :service do
  gem "google-cloud-tasks"
  gem "line-bot-api"
end

group :development do
  gem "debug"
  gem "rerun"
  gem "rubocop", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-shopify", require: false
end

group :test do
  gem "rspec"
  gem "rack-test"
end
