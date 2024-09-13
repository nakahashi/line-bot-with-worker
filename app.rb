# frozen_string_literal: true

require "sinatra"
require_relative "app/controllers/line_bot_controller"

class App < Sinatra::Base
  configure do
    set :bind, "0.0.0.0"
    set :port, ENV["PORT"] || 8080
  end

  use LineBotController
end
