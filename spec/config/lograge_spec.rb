# frozen_string_literal: true

require "rails_helper"

describe Lograge do
  let(:app) { Rails.application }

  before do
    Lograge.setup(app)
  end

  describe "handling custom append_info_to_payload method" do
    let(:controller) do
      cntr = CoreBy::SDK::ApplicationController.new
      cntr.instance_variable_set(:@current_user, Struct.new(:id).new(1234))
      cntr.request = request
      cntr
    end
    let(:payload) { {timestamp: Date.parse("5-11-1955")} }
    let(:request) { double(env: {}, remote_ip: "some-ip", uuid: "2bc54279-d4dc-45d6-8eea-186103c5f160", user_agent: "iphone") }

    subject { payload.dup }

    before do
      controller.append_info_to_payload(subject)
    end

    it "will append user_id and ip if available" do
      expect(subject).to include(payload.merge({user_id: 1234, ip: "some-ip", uuid: "2bc54279-d4dc-45d6-8eea-186103c5f160"}))
    end
  end

  describe "handling custom_options from events" do
    let(:log_output) { StringIO.new }
    let(:logger) do
      Logger.new(log_output).tap { |logger| logger.formatter = ->(_, _, _, msg) { msg } }
    end

    let(:subscriber) { Lograge::LogSubscribers::ActionController.new }
    let(:event_params) { {"foo" => "bar"} }
    let(:event_type) { "process_action.action_controller" }

    let(:event) do
      ActiveSupport::Notifications::Event.new(
        event_type,
        Time.now,
        Time.now,
        2,
        status: 200,
        controller: "CoreBy::SDK::ApplicationController",
        action: "index",
        format: "application/json",
        method: "GET",
        path: "/home?foo=bar",
        params: event_params,
        user_id: 1234,
        db_runtime: 0.02,
        view_runtime: 0.01
      )
    end

    before do
      Lograge.logger = logger
      Lograge.formatter = ->(data) { "My test: #{data}" }
    end

    it "combines the hash properly for the output" do
      subscriber.process_action(event)
      expect(log_output.string).to match(/^My test: {.*:params=>{"foo"=>"bar"}/)
      expect(log_output.string).to match(/:user_id=>1234/)
    end

    context "when event is an action_cable event" do
      let(:event_type) { "process_action.action_cable" }

      it "ignores params and other custom payload" do
        subscriber.process_action(event)
        expect(log_output.string).to match(/^My test: {/)
        expect(log_output.string).not_to match(/:params=>{"foo"=>"bar"}/)
        expect(log_output.string).not_to match(/:user_id=>1234/)
      end
    end
  end
end
