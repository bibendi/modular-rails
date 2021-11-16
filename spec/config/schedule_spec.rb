# frozen_string_literal: true

require "rails_helper"

describe Schked do
  let(:worker) { described_class.worker.tap(&:pause) }

  let(:time_zone) { "UTC" }

  around do |ex|
    Time.use_zone(time_zone) do
      travel_to(start_time, &ex)
    end
  end

  describe "Schked healthcheck" do
    let(:job) { worker.job("Schked healthcheck") }
    let(:start_time) { Time.zone.local(2008, 9, 1, 2, 30, 10) }
    let(:next_minute) { Time.zone.local(2008, 9, 1, 2, 31, 0) }

    it "executes every minute" do
      expect(job.next_time.to_local_time).to eq(next_minute)
    end

    it "touches status file" do
      allow(FileUtils).to receive(:touch)
      status_file_path = Rails.root.join("tmp", "schked.status")
      job.call(false)
      expect(FileUtils).to have_received(:touch).with(status_file_path)
    end
  end
end
