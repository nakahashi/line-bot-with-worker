# frozen_string_literal: true

require "faraday"
require "json"

class Worker
  def initialize
    @tasks_client = Faraday.new(url: "#{ENV["WORKER_URL"]}:#{ENV["PORT"]}")
  end

  def perform(payload)
    @tasks_client.post("/worker") do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = { payload: }.to_json
    end
  end
end
