# frozen_string_literal: true

class AddEventRegistrationsEventsUserUniqueness < ActiveRecord::Migration[5.2]
  def change
    add_index :event_registrations, %i[event_id user_id], unique: true
  end
end
