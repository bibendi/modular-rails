# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def up
    create_enum :user_role, %w[member manager admin]
    create_enum :membership_state, %w[active disabled]

    create_table :users do |t|
      t.string :login
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.enum :role, enum_name: :user_role, null: false, default: "member"
      t.enum :membership_state, enum_name: :membership_state, null: false, default: "active"
      t.datetime :deleted_at
      t.boolean :receive_emails, null: false, default: true
      t.timestamps null: false
    end

    add_index :users, "lower((login)::text)", name: "index_users_on_login", unique: true
    add_index :users, :phone, unique: true
    add_index :users, "lower((email)::text)", name: "index_users_on_email", unique: true
  end

  def down
    drop_table :users

    drop_enum :user_role
    drop_enum :membership_state
  end
end
