# frozen_string_literal: true

class EventRegistration < ApplicationRecord
  belongs_to :event
  belongs_to :user
  validates_uniqueness_of :user_id, scope: :event_id
  validate :event_must_be_approved

  def event_must_be_approved
    errors.add(:event, 'must be approved') unless event.approved?
  end
end
