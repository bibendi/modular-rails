# frozen_string_literal: true

class CreateInterests < ActiveRecord::Migration[6.1]
  def change
    create_table :interests do |t|
      t.text :name, null: false

      t.index :name, unique: true

      t.timestamps
    end
  end
end
