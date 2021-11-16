# frozen_string_literal: true

class SorceryInstall < ActiveRecord::Migration[6.0]
  def change
    # Sorcery core
    add_column :users, :crypted_password, :string
    add_column :users, :salt, :string

    # Sorcery remember_me
    add_column :users, :remember_me_token, :string
    add_column :users, :remember_me_token_expires_at, :datetime

    add_index :users, :remember_me_token, unique: true

    # Sorcery reset_password
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_token_expires_at, :datetime
    add_column :users, :reset_password_token_generated_at, :datetime

    add_index :users, :reset_password_token, unique: true
  end
end
