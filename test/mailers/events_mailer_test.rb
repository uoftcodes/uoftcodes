# frozen_string_literal: true

require 'test_helper'

class EventsMailerTest < ActionMailer::TestCase
  test '#register_email' do
    event_registration = create(:event_registration)

    email = EventsMailer.register_email(event_registration)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [event_registration.user.email], email.to
  end

  test '#unregister_email' do
    user = create(:user)
    event = create(:event)

    email = EventsMailer.unregister_email(user, event)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [user.email], email.to
  end

  test '#approve_email' do
    event = create(:event)

    email = EventsMailer.approve_email(event)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [event.user.email], email.to
  end

  test '#reminder_email' do
    event_registration = create(:event_registration)

    email = EventsMailer.reminder_email(event_registration)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [event_registration.user.email], email.to
  end

  test '#creation_email' do
    user = create(:user)
    event = create(:event)

    email = EventsMailer.creation_email(event, user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [user.email], email.to
  end
end
