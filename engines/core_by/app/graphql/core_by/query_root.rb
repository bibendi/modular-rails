# frozen_string_literal: true

module CoreBy
  class QueryRoot < SDK::Schema::Object
    field :time, SDK::Types::DateTime, "Current server time", null: false
    field :job_status, SDK::Types::JSONString, "Check the status of a job", null: true do
      argument :job_id, ID, required: true
    end

    with_options authenticate: true do
      field :me, Types::Me, "Current user's sub-graph", null: true
    end

    field :member, SDK::Types::User, "Member record", null: false do
      argument :id, ID, "Member ID", required: false
      argument :login, String, "Member login", required: false
    end

    def time
      Time.now
    end

    def job_status(job_id:)
      ActiveJob::Status.get(job_id)
    end

    def me
      current_user
    end

    def member(id: nil, login: nil)
      scope = CoreBy::User.active_members

      if id
        scope.find_by!(external_id: id)
      elsif login
        scope.find_by_login!(login)
      else
        raise ActiveRecord::RecordNotFound
      end
    end
  end

  ActiveSupport.run_load_hooks("core_by/query_root", QueryRoot)
end
