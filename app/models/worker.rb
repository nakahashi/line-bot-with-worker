# frozen_string_literal: true

require "google/cloud/tasks"
require "json"
require "base64"

class Worker
  class << self
    def perform(payload)
      tasks_client = Google::Cloud::Tasks.cloud_tasks

      project = ENV["PROJECT_ID"]
      location = ENV["REGION"]
      queue = ENV["WORKER_QUEUE"]
      parent = tasks_client.queue_path(project:, location:, queue:)

      url = "#{ENV["WORKER_URL"]}/worker"
      task = {
        http_request: {
          http_method: :POST,
          url:,
          oidc_token: {
            service_account_email: ENV["WORKER_SERVICE_ACCOUNT"],
          },
          headers: { "Content-Type": "application/json" },
          body: Base64.encode64({ payload: }.to_json),
        },
      }

      tasks_client.create_task(parent:, task:)
    end

    def parse_payload(body)
      decoded_body = Base64.decode64(body)
      parsed_body = JSON.parse(decoded_body)
      parsed_body["payload"]
    end
  end
end
