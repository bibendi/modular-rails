# frozen_string_literal: true

module CoreBy
  class MutationRoot < SDK::Schema::Object
    with_options authenticate: true do
      field :create_direct_upload, mutation: Mutations::CreateDirectUpload

      field :discard_profile, mutation: Mutations::Profile::Discard
      field :update_profile_info, mutation: Mutations::Profile::UpdateInfo
      field :attach_profile_avatar, mutation: Mutations::Profile::AttachAvatar
    end
  end

  ActiveSupport.run_load_hooks("core_by/mutation_root", MutationRoot)
end
