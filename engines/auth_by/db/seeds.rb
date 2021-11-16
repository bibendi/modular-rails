# frozen_string_literal: true

require "common-factory"
require "core_by/seeds/dsl"

using CoreBy::Seeds::DSL

announce "Users" do
  AuthBy::User.find_each do |user|
    user.update!(password: "qwerty")
  end

  announce "Set password for all users as `qwerty`"
end
