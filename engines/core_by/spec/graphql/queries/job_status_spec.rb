# frozen_string_literal: true

require "rails_helper"

class TestJobStatus < CoreBy::SDK::ApplicationJob
  track_status

  def perform
    status.update(foo: true)
  end
end

describe "{ jobStatus { ... } }" do
  let(:query) do
    <<~GRAPHQL
      query getJobStatus($jobId: ID!) {
        jobStatus(jobId: $jobId)
      }
    GRAPHQL
  end

  let(:variables) { {job_id: job_id} }

  let(:job_id) { "missing-id" }
  let(:json_data) { JSON.parse(data) }

  it "returns json" do
    expect(json_data).to be_empty
  end

  context "when a job in the queue" do
    let(:job_id) { TestJobStatus.perform_later.job_id }

    it "returns json" do
      expect(json_data).to include("status" => "queued")
    end
  end

  context "when a job is performed" do
    let(:job_id) do
      job = TestJobStatus.perform_later
      job.perform_now
      job.job_id
    end

    it "returns json" do
      expect(json_data).to include("status" => "completed", "foo" => true)
    end
  end
end
