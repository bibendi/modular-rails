# frozen_string_literal: true

class AddBruteForceProtectionAttrsOnUsers < ActiveRecord::Migration[6.1]
  def change
    # https://github.com/Sorcery/sorcery/blob/master/lib/sorcery/model/submodules/brute_force_protection.rb
    change_table :users do |t|
      t.integer :failed_logins_count, default: 0, null: false
      t.datetime :lock_expires_at
      t.string :unlock_token

      t.index :unlock_token, unique: true
    end
  end
end
