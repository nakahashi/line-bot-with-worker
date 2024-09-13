# frozen_string_literal: true

require "faraday"
require "json"

class Worker
  def initialize
    @tasks_client = Faraday.new(url: "#{ENV["BOT_URL"]}:#{ENV["PORT"]}")
  end

  def perform(message)
    @tasks_client.post("/worker") do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = { message: }.to_json
    end
  end
end
