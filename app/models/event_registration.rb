# frozen_string_literal: true

class EventRegistration < ApplicationRecord
  belongs_to :event
  belongs_to :user
  validates_uniqueness_of :user_id, scope: :event_id
  validate :event_must_be_approved

  after_create :send_registration_email, if: :user_takes_registration_emails?
  after_destroy :send_unregistration_email, if: :user_takes_registration_emails?

  def event_must_be_approved
    errors.add(:event, 'must be approved') unless event.approved?
  end

  def user_takes_registration_emails?
    user.event_registration_email?
  end

  def send_registration_email
    EventsMailer.register_email(self).deliver_later
  end

  def send_unregistration_email
    EventsMailer.unregister_email(user, event).deliver_later
  end
end
