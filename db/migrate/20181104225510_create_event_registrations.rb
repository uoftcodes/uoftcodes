# frozen_string_literal: true

class CreateEventRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :event_registrations do |t|
      t.references :events
      t.references :user

      t.timestamps
    end
  end
end
