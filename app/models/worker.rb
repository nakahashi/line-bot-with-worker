# frozen_string_literal: true

require "google/cloud/tasks"
require 'googleauth'
require 'googleauth/id_tokens'
require "json"

class Worker
  def initialize
    @tasks_client = Google::Cloud::Tasks.cloud_tasks
  end

  def perform(payload)
    project = ENV["PROJECT_ID"]
    location = ENV["REGION"]
    queue = ENV["WORKER_QUEUE"]
    parent = @tasks_client.queue_path(project:, location:, queue:)

    url = "#{ENV["WORKER_URL"]}/worker"
    task = {
      http_request: {
        http_method: :POST,
        url:,
        headers: { "Content-Type": "application/json" },
        body: { payload: }.to_json,
      },
    }

    @tasks_client.create_task(parent:, task:)
  end

  def self.authenticate!(request)
    auth_header = request.env['HTTP_AUTHORIZATION']

    raise "Unauthorized" if auth_header.nil?

    token = auth_header.split(' ').last
    oidc_token_hash = Google::Auth::IDTokens.verify_oidc(token, aud: request.url)

    raise "Unauthorized" unless oidc_token_hash['email'] == ENV.fetch('WORKER_SERVICE_ACCOUNT_EMAIL')
  end
end
