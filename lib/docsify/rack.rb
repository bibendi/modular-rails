# frozen_string_literal: true

module Docsify
  class Rack
    attr_reader :docs_handler, :custom_handlers, :overrides

    def initialize
      @docs_handler = handler_for("docs")

      # other handlers to serve engines/gems docs
      # and other files out of the `docs/` folder
      #
      # NOTE: make sure you have strong enough masks to avoid exposing
      # the application code.
      @custom_handlers = [
        [%r{^(/~engines)/[\w_-]+/(docs/|[^/]+.md)}, handler_for("engines")],
        [%r{^(/~gems)/[\w_-]+/(docs/|[^/]+.md)}, handler_for("gems")],
        [%r{^(/~home)/[^/]+.md}, handler_for("./")]
      ].freeze

      # override paths
      @overrides = {
        # Use Readme.md as a sidebar.
        # We cannot just set `loadSidebar: 'README.md`, 'cause tries to load
        # this file for every subfolder
        "/_sidebar.md" => "/README.md"
      }.freeze
    end

    def call(env)
      req = ::Rack::Request.new env

      return not_found unless req.get? || req.head?

      path = req.path_info.chomp("/")

      # remove double docs (from root files, e.g. ./README.md)
      path.sub!(/^\/docs/, "")

      path = overrides[path] || path

      handler =
        if path.start_with?("/~")
          custom_handlers.find do |(pattern, _handler)|
            next false unless path.match(pattern)
            path.sub!(Regexp.last_match[1], "")
            true
          end&.last
        end

      handler ||= docs_handler

      env["PATH_INFO"] = path
      handler.attempt(env) || not_found
    end

    private

    def handler_for(root, index: "index", headers: {})
      ActionDispatch::FileHandler.new(
        root, index: index,
              headers: headers
      )
    end

    def not_found
      [404, {"Content-Type" => "text/html"}, []]
    end
  end
end
