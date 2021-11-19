# frozen_string_literal: true

require "common-factory"
require "core_by/seeds/dsl"

using CoreBy::Seeds::DSL

files_dir = File.expand_path("../spec/fixtures/files", __dir__)

announce "Managers" do
  create(
    :admin,
    login: "admin",
    email: "admin@example.com",
    avatar: Rack::Test::UploadedFile.new(File.join(files_dir, "avatar.jpg"), "image/jpeg")
  )

  create(
    :manager,
    login: "manager",
    email: "manager@example.com",
    avatar: Rack::Test::UploadedFile.new(File.join(files_dir, "avatar.jpg"), "image/jpeg")
  )
end

announce "Members" do
  create(
    :member,
    phone: "+12025552200",
    login: "member",
    email: "member@example.com",
    avatar: Rack::Test::UploadedFile.new(File.join(files_dir, "avatar.jpg"), "image/jpeg")
  )

  create(
    :member,
    phone: "+12025552201",
    login: "member.a",
    email: "member.a@example.com",
    avatar: Rack::Test::UploadedFile.new(File.join(files_dir, "avatar.jpg"), "image/jpeg")
  )

  create(
    :member,
    :disabled,
    name: "disabled member",
    phone: "+12025552205",
    login: "member.disabled",
    email: "member-disabled@example.com",
    avatar: Rack::Test::UploadedFile.new(File.join(files_dir, "avatar.jpg"), "image/jpeg")
  )
end
