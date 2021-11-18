# frozen_string_literal: true

namespace :graphql do
  desc "Dump GraphQL schema to db/schema.gql or FILE env"
  task dump: :environment do
    filename = ENV.fetch("FILE", "db/schema.gql")
    File.open(Rails.root.join(filename), "w") do |file|
      file.write(CoreBy::ApplicationSchema.to_definition)
    end
  end
end
