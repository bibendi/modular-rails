# frozen_string_literal: true

cron "* * * * *", as: "Schked healthcheck" do
  FileUtils.touch(Rails.root.join("tmp", "schked.status"))
end
