# frozen_string_literal: true

class RenameEventsToEvent < ActiveRecord::Migration[5.2]
  def change
    rename_column :event_registrations, :events_id, :event_id
  end
end
