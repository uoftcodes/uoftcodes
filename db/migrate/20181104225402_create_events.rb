# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :user
      t.string :title, null: false
      t.string :location, null: false
      t.binary :banner
      t.text :description, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end
