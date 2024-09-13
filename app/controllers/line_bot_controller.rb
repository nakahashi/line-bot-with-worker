# frozen_string_literal: true

require "line/bot"
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

          Worker.new.perform(payload)
        end
      end
    end
  end

  post "/worker" do
    p "サービスアカウント認証 done!"
    payload = JSON.parse(request.body.read)["payload"]

    message = {
      type: "text",
      text: payload["message"],
    }
    @client.reply_message(payload["token"], message)
  end
end
