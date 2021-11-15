# frozen_string_literal: true

# Generates a user.
# The user's name is "James Black".
shared_context "core_by:user" do
  let_it_be(:user, refind: true) do
    create(:user,
      login: "inspiration",
      first_name: "James",
      last_name: "Black")
  end
end

RSpec.configure do |config|
  config.include_context "core_by:user", user: true
end
