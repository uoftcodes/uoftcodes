# frozen_string_literal: true

class AddNotificationPreferencesToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :event_registration_email, :boolean, null: false, default: true
    add_column :users, :event_reminder_email, :boolean, null: false, default: true
    add_column :users, :event_creation_email, :boolean, null: false, default: true
  end
end
