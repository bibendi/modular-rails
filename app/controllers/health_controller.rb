# frozen_string_literal: true

class HealthController < CoreBy::BaseController
  def live
    # check master db connection
    ActiveRecord::Base.connection.execute("select 1;")

    head :ok
  end
end
