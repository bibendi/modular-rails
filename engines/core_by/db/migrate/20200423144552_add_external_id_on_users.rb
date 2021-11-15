# frozen_string_literal: true

class AddExternalIdOnUsers < ActiveRecord::Migration[6.0]
  def change
    enable_extension "uuid-ossp"

    change_table :users do |t|
      t.uuid :external_id, null: false, default: -> { "uuid_generate_v4()" }

      t.index :external_id, unique: true
    end
  end
end
