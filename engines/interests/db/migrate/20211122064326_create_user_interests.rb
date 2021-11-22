# frozen_string_literal: true

class CreateUserInterests < ActiveRecord::Migration[6.1]
  def change
    create_table :user_interests do |t|
      t.bigint :user_id, null: false
      t.bigint :interest_id, null: false

      t.index [:user_id, :interest_id], unique: true
      t.index :interest_id

      t.foreign_key :users, on_delete: :cascade
      t.foreign_key :interests, on_delete: :cascade

      t.timestamps
    end
  end
end
