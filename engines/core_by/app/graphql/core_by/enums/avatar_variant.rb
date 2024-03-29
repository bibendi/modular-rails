# frozen_string_literal: true

module CoreBy
  module Enums
    class AvatarVariant < SDK::Schema::AttachmentVariantEnum
      variants_for CoreBy::User, :avatar
    end
  end
end
