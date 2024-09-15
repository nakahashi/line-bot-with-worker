# frozen_string_literal: true

require "line/bot"
require "base64"
require_relative "../models/worker"

unless production?
  require_relative "../../mock/models/worker"
  require_relative "../../mock/lib/line_bot"
end

class LineBotController < Sinatra::Base
  before do
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
  end

  post "/callback" do
    body = request.body.read

    signature = request.env["HTTP_X_LINE_SIGNATURE"]
    unless @client.validate_signature(body, signature)
      halt 400, { "Content-Type" => "text/plain" }, "Bad Request"
    end

    events = @client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          payload = {
            token: event["replyToken"],
            message: event.message["text"],
          }

          Worker.perform(payload)
        end
      end
    end

    response_body = "OK"
    headers["Content-Length"] = response_body.bytesize.to_s
    response_body
  end

  if ENV["WORKER_SERVICE"]
    post "/worker" do
      payload = Worker.parse_payload(request.body.read)

      text = payload["message"]
      message = {
        type: "text", text:,
      }
      @client.reply_message(payload["token"], message)
    end
  end
end
