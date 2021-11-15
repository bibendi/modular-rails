# frozen_string_literal: true

module CoreBy
  module Seeds
    SPACE = " "

    class << self
      attr_accessor :depth

      def announce(msg)
        $stdout.puts pad(msg)

        return unless block_given?

        self.depth += 1
        yield
        self.depth -= 1
      end

      def pad(msg)
        return msg if depth.zero?

        "#{SPACE * depth * 2} ↳ #{msg}"
      end

      def pretty_params(params)
        params.each_with_object([]) do |(key, val), acc|
          acc << if val.is_a?(ActiveRecord::Base)
            "#{key}: #{val.class.model_name.human}(##{val.id})"
          else
            "#{key}: #{val}"
          end
        end.join(", ")
      end
    end

    self.depth = 0

    # Adds FactoryBot syntax methods with
    # logging
    module DSL
      refine Object do
        def announce(msg, &block)
          Seeds.announce(msg, &block)
        end

        def create(factory, *traits, **params)
          FactoryBot.create(factory, *traits, **params).tap do |record|
            traits_msg = traits.any? ? " (#{traits.join(", ")})" : ""
            params_msg = params.any? ? " with #{Seeds.pretty_params(params)}" : ""

            announce "created #{factory.to_s.camelize}(##{record.id})#{traits_msg}#{params_msg}"
          end
        end

        def create_batch(batch_size, factory, *traits, **params)
          created = []
          batch_size.times do |n|
            nth_params = params.clone
            nth_params.keys.each do |k|
              next unless nth_params[k].is_a?(String)
              nth_params[k] = nth_params[k].gsub("%%", "%03d" % n)
            end
            created << FactoryBot.create(factory, *traits, **nth_params)
          end
          traits_msg = traits.any? ? " (#{traits.join(", ")})" : ""
          params_msg = params.any? ? " with #{Seeds.pretty_params(params)}" : ""

          announce "created batch of #{created.size} #{factory.to_s.camelize}s#{traits_msg}#{params_msg}"
          created
        end
      end
    end
  end
end
