# frozen_string_literal: true

module CoreBy
  module SDK
    module Users
      module OnCreated
        module AddDefaultInterest
          # Just an example
          DEFAULT_INTEREST = "Sport"

          def self.call(event)
            interest = Interests::Interest.find_by_name(DEFAULT_INTEREST)
            return unless interest

            Interests::UserInterest.create!(interest: interest, user_id: event.user.id)
          end
        end
      end
    end
  end
end
