# frozen_string_literal: true

require "rails_helper"

describe CoreBy::SDK::ApplicationForm do
  describe ".attributes" do
    let(:form_class) do
      Class.new(described_class) do
        attributes :a, :b
      end
    end

    it "generates accessors" do
      form = form_class.new(a: 1)
      form.b = "2"

      expect(form).to have_attributes(
        a: 1,
        b: "2"
      )
    end

    context "inheritance" do
      let(:sub_class) do
        Class.new(form_class) do
          attributes :c
        end
      end

      it "uses its own attributes_map" do
        expect(form_class.new).not_to respond_to(:c)
        expect(sub_class.new).to respond_to(:c)
      end
    end

    context "type casting" do
      let(:typed_class) do
        Class.new(form_class) do
          attribute :private, :boolean
        end
      end

      it "transforms values on initialization" do
        form = typed_class.new(
          private: "1"
        )

        expect(form.private).to eq true
        expect(form).to be_private
      end
    end

    context "defaults" do
      let(:defaults_class) do
        Class.new(form_class) do
          attribute :private, :boolean, default: true
        end
      end

      it "populates defaults" do
        form = defaults_class.new
        expect(form.private).to eq true

        form = defaults_class.new(private: "0")
        expect(form.private).to eq false
      end
    end
  end

  describe "#errors" do
    let(:form_class) do
      Class.new(described_class) do
        def self.name
          "TestForm"
        end

        attributes :a, :b

        validates :a, :b, presence: true
        validates :b, inclusion: {in: [0, 1]}
      end
    end

    it "contains form validation errors" do
      form = form_class.new

      expect(form).not_to be_valid

      expect(form.errors.messages[:a]).to include("can't be blank")
      expect(form.errors.messages[:b]).to include("can't be blank", "is not included in the list")
    end
  end

  describe "#save" do
    let(:form_class) do
      Class.new(described_class) do
        def self.name
          "TestForm"
        end

        attributes :a, :b

        validates :a, presence: true

        attr_reader :result

        def persist!
          @result = :ok
        end
      end
    end

    it "calls #persist! when valid and returns a status" do
      form = form_class.new(a: 1, b: 2)
      expect(form.save).to eq true
      expect(form.result).to eq :ok
    end

    it "returns false and doesn't call #persist! when not valid" do
      form = form_class.new(b: 2)
      expect(form.save).to eq false
      expect(form.result).to be_nil
    end

    context "when #persist! is not defined" do
      let(:form_class) do
        Class.new(described_class)
      end

      it "raises NonImplemented error" do
        expect { form_class.new.save }.to raise_error(NotImplementedError, /#persist! must be defined/)
      end
    end
  end
end
