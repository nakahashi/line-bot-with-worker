require 'sinatra'
require_relative './app/controllers/line_bot_controller'

configure do
  set :bind, '0.0.0.0'
  set :port, ENV['PORT'] || 8080
end

class App < Sinatra::Base
  use LineBotController
end
