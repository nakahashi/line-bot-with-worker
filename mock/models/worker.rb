# frozen_string_literal: true

require "faraday"
require "json"
require "base64"

class Worker
  class << self
    def perform(payload)
      tasks_client = Faraday.new(url: "#{ENV["WORKER_URL"]}:#{ENV["PORT"]}")

      tasks_client.post("/worker") do |req|
        req.headers["Content-Type"] = "application/json"
        req.body = Base64.encode64({ payload: }.to_json)
      end
    end
  end
end
