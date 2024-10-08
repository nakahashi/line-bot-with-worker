# frozen_string_literal: true

ENV["RACK_ENV"] ||= "test"

require "rack/test"
require "rspec"
require_relative "../app"

module RSpecMixin
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.mock_with :rspec
end
