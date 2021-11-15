# frozen_string_literal: true

cron "* */12 * * *", as: "CoreBy::Recurring::CleanGraphQLSubscriptionsJob" do
  CoreBy::Recurring::CleanGraphQLSubscriptionsJob.perform_later
end

cron "0 9 * * 1", as: "CoreBy::Recurring::CleanVersionsTableJob" do
  CoreBy::Recurring::CleanVersionsTableJob.perform_later
end
