# frozen_string_literal: true

source "https://rubygems.org"

ruby File.read(File.join(__dir__, ".ruby-version")).strip

gem "rails", File.read(File.join(__dir__, ".rails-version"))

# == Core ==
gem "pg"
gem "puma", "~> 5.2", ">= 5.2.2"
gem "redis"
gem "sidekiq"

# == Configuration ==
# Multi-source configuration
# https://github.com/palkan/anyway_config
gem "anyway_config"

# Template language for views
# http://slim-lang.com
gem "slim-rails"

# == Active Storage ==
# GCS SDK
gem "google-cloud-storage", require: false

# Rufus-scheduler wrapper to run recurring jobs
gem "schked"

# == Performance ==
# Speed up application code loading
# https://github.com/Shopify/bootsnap
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

# == Security ==
# Rack middleware for blocking & throttling abusive requests
# https://github.com/kickstarter/rack-attack
gem "rack-attack"

# Taming Rails' Default Request Logging
# https://github.com/roidrage/lograge
gem "lograge"

# PostgreSQL database performance insights.
# Locks, index usage, buffer cache hit ratios, vacuum stats and more.
# https://github.com/pawurb/rails-pg-extras
gem "rails-pg-extras"

# Catch unsafe migrations
# https://github.com/ankane/strong_migrations
gem "strong_migrations"

group :production, :staging do
  # Sentry.io agent
  # https://sentry.io/organizations/vicinity/projects/
  gem "sentry-raven"

  # https://rpm.newrelic.com/accounts/2645801
  gem "newrelic_rpm"

  # == Monitoring ==
  gem "yabeda"
  # Sidekiq worker metrics
  gem "yabeda-sidekiq"
  # Per-query and per-field GraphQL monitoring
  gem "yabeda-graphql"
  # Prometheus support and metrics exporter
  gem "yabeda-prometheus-mmap"
  # Puma internal metrics and app metrics exporter
  gem "yabeda-puma-plugin", "~> 0.4"
  # Basic Rails built-in metrics and Yabeda autoconfiguration
  gem "yabeda-rails"
  # Schked recurring jobs metrics
  gem "yabeda-schked"
  # Collect performance metrics for AnyCable RPC server
  gem "yabeda-anycable"
end

group :development, :test do
  # Add rspec-rails to both development and test
  # to be able to use generators
  gem "rspec-rails", require: ["rspec", "rspec-rails"]

  # == Security/Audit
  # Check for known CVE in gems
  gem "bundler-audit", require: false
end

group :development do
  # Debugger
  gem "debug", "~> 1.1"

  path "gems" do
    # Shared RuboCop configuration
    gem "common-rubocop", require: false
  end

  gem "rubocop", "= 1.20.0" # The Lint/Env Exlude option doesn't work in higher versions
  gem "standard", "= 1.3.0" # The Lint/Env Exlude option doesn't work in higher versions

  # Used by reloader to watch files changes
  gem "listen"

  # Used by danger to authenticate GitHub app
  gem "jwt", require: false

  # == Linters
  # Check for consistency between validations and db constraints
  # https://github.com/djezzzl/database_consistency
  gem "database_consistency", require: false

  # Takes two GraphQL schemas and outputs a list of changes between versions
  # e.g.:
  #   rails r 'puts CoreBy::ApplicationSchema.to_definition' > tmp/gql_schema_new
  #   bundle exec schema_comparator compare tmp/gql_schema_old tmp/gql_schema_new
  gem "graphql-schema_comparator"
end

group :test do
  path "gems" do
    # Shared RSpec configuration
    gem "common-testing", require: false
  end
end

# == Engines ==
def engine(name)
  Dir.chdir(__dir__) do
    group name.to_sym do
      group :default do
        # Add engine as a dependency
        gem name, path: "engines/#{name}"
      end

      # Add development deps to development and test groups
      gem "#{name}-dev", path: "engines/#{name}", group: [:development, :test]
    end
  end
end

path "engines" do
  engine "core_by"
  engine "auth_by"
end
