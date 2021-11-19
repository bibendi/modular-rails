# frozen_string_literal: true

require "rails_helper"

class TestEntityRecord
  def foo
    "foo"
  end

  def bar
    "bar"
  end
end

class TestEntity < CoreBy::Base::Entity
  delegate_attrs :foo

  def bar
    "new bar"
  end
end

describe CoreBy::Base::Entity do
  let(:record) { TestEntityRecord.new }
  let(:entity) { TestEntity.new(record) }

  it "delegates attributes" do
    expect(entity.foo).to eq "foo"
    expect(entity.bar).to eq "new bar"
  end
end
