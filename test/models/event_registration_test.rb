# frozen_string_literal: true

require 'test_helper'

class EventRegistrationTest < ActiveSupport::TestCase
  test '#event_must_be_approved validation' do
    member = create(:user, user_type: :member)
    non_approved_event = create(:event, approved: false)

    event_registration = EventRegistration.new(user: member, event: non_approved_event)

    refute event_registration.save
  end

  test 'registration email is sent when created and user receives registration emails' do
    member = create(:user, user_type: :member)
    event = create(:event)

    assert_emails 1 do
      perform_enqueued_jobs do
        EventRegistration.create(user: member, event: event)
      end
    end
  end

  test 'registration email is not sent when created and user does not receive registration emails' do
    member = create(:user, user_type: :member, event_registration_email: false)
    event = create(:event)

    assert_no_emails do
      perform_enqueued_jobs do
        EventRegistration.create(user: member, event: event)
      end
    end
  end

  test 'unregistration email is sent when destroyed and user receives registration emails' do
    member = create(:user, user_type: :member)
    event = create(:event)

    event_registration = nil
    perform_enqueued_jobs do
      event_registration = EventRegistration.create(user: member, event: event)
    end

    assert_emails 1 do
      perform_enqueued_jobs do
        event_registration.destroy!
      end
    end
  end

  test 'unregistration email is not sent when destroyed and user does not receive registration emails' do
    member = create(:user, user_type: :member, event_registration_email: false)
    event = create(:event)

    event_registration = nil
    perform_enqueued_jobs do
      event_registration = EventRegistration.create(user: member, event: event)
    end

    assert_no_emails do
      perform_enqueued_jobs do
        event_registration.destroy!
      end
    end
  end
end
