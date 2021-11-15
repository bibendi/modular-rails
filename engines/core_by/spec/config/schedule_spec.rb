# frozen_string_literal: true

require "rails_helper"

describe Schked do
  let(:worker) { described_class.worker.tap(&:pause) }

  let(:time_zone) { "UTC" }

  let(:start_time) { Time.zone.local(2008, 8, 1, 2, 30, 10) }

  around do |ex|
    Time.use_zone(time_zone) do
      travel_to(start_time, &ex)
    end
  end

  describe "CoreBy::Recurring::CleanGraphQLSubscriptionsJob" do
    let(:job) { worker.job("CoreBy::Recurring::CleanGraphQLSubscriptionsJob") }

    let(:next_12_hours) { Time.zone.local(2008, 8, 1, 12, 0, 0) }

    specify do
      expect(job.next_time.to_local_time)
        .to eq next_12_hours
    end

    it "enqueues job" do
      expect do
        job.call(false)
      end.to have_enqueued_job(
        CoreBy::Recurring::CleanGraphQLSubscriptionsJob
      )
    end
  end

  describe "CoreBy::Recurring::CleanVersionsTableJob" do
    let(:job) { worker.job("CoreBy::Recurring::CleanVersionsTableJob") }

    let(:next_monday) { Time.zone.local(2008, 8, 4, 9, 0, 0) }

    specify do
      expect(job.next_time.to_local_time)
        .to eq next_monday
    end

    it "enqueues job" do
      expect do
        job.call(false)
      end.to have_enqueued_job(
        CoreBy::Recurring::CleanVersionsTableJob
      )
    end
  end
end
