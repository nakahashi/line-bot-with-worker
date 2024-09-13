require 'google/cloud/tasks'
require 'json'

class Worker
  def initialize
    @tasks_client = Google::Cloud::Tasks.cloud_tasks
  end

  def perform(payload)
    project = ENV['PROJECT_ID']
    location = ENV["REGION"]
    queue = ENV["TASK_QUEUE"]
    parent = @tasks_client.queue_path(project:, location:, queue:)

    url = "#{ENV['BOT_URL']}/worker"
    task = {
      http_request: {
        http_method: :POST,
        url:,
        headers: { "Content-Type": "application/json" },
        body: { payload: }.to_json
      }
    }

    @tasks_client.create_task(parent:, task:)
  end
end
