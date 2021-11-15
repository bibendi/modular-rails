# frozen_string_literal: true

GraphdocRuby.configure do |config|
  config.executable_path = Rails.root.join("node_modules", ".bin", "graphdoc").to_s
  config.endpoint = Rails.root.join("tmp", "graphql", "schema.json")
  config.output_directory = Rails.root.join("tmp", "graphdoc").to_s
  config.schema_name = "CoreBy::ApplicationSchema"
  # we need to provide context to make all API fields visible to introspection query
  config.graphql_context = -> { {current_user: Struct.new(:community_manager?).new(true)} }
  config.run_time_generation = false
end

if Rails.application.config.graphdoc_run_time
  # Regenerate schema when graphql/**/*.rb files changes
  reloadable_paths = Dir[
    Rails.root.join("engines", "*", "app/graphql", "**", "*.rb").to_s
  ] + Dir[
    Rails.root.join("app/graphql", "**", "*.rb").to_s
  ]

  reloadable_dirs = reloadable_paths.each_with_object({}) do |path, acc|
    acc[File.dirname(path)] = %w[.rb]
  end

  reloader = Rails.application.config.file_watcher.new(reloadable_paths, reloadable_dirs) do
    $stdout.print "Re-generating GraphQL schema.json... "
    # Make sure CoreBy::GraphQLSchema is loaded, 'cause graphdoc uses `const_get`
    CoreBy::ApplicationSchema # rubocop:disable Lint/Void

    begin
      GraphdocRuby::GraphqlJson.write_schema_json
      # Force regeneration
      GraphdocRuby.config.instance_variable_set(:@mtime, Time.now)
      GraphdocRuby::Application.graphdoc.generate_document!

      $stdout.puts "Complete."
    rescue => e
      $stdout.puts "Failed to generate graphdoc documentation: #{e.message}"
    end
  end

  # Register callback to run when Rails reloader
  # detects changes
  Rails.application.reloader.to_run do
    reloader.execute_if_updated
  end

  # Add reloader to the list of reloders.
  # Rails run `reloader.to_run` (above) only if
  # at least one of the reloaders has updates
  Rails.application.reloaders << reloader
end
