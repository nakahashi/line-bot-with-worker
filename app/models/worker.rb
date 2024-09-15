# frozen_string_literal: true

require "google/cloud/tasks"
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
        oidc_token: {
          service_account_email: ENV["WORKER_SERVICE_ACCOUNT"]
        },
        headers: { "Content-Type": "application/json" },
        body: { payload: }.to_json,
      },
    }

    @tasks_client.create_task(parent:, task:)
  end
end
