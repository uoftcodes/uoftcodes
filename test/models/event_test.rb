# frozen_string_literal: true

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    @new_event_email_regex = /New event/
    @approve_event_email_regex = /Your event has been approved/
  end

  test 'validation fails for a event with end time before start time' do
    event = create(:event, approved: true)

    event.start_time = Time.zone.now - 1.hour
    event.end_time = Time.zone.now - 5.hour

    assert_raises ActiveRecord::RecordInvalid do
      event.save!
    end
  end

  test 'validation fails for a event where the user is not a lecturer' do
    event = create(:event, approved: true)

    event.user = create(:user)

    assert_raises ActiveRecord::RecordInvalid do
      event.save!
    end
  end

  test 'approval email is sent to the creator of the event' do
    lecturer = create(:user, user_type: :lecturer)
    event = create(:event, user: lecturer, approved: false)

    assert_emails 2 do
      perform_enqueued_jobs do
        event.approved = true
        event.save!
      end
    end

    email_deliveries = ActionMailer::Base.deliveries

    assert email_deliveries.any? do |email|
      email.to.include?(member.email) &&
        /New event/.match?(email.subject)
    end
    assert email_deliveries.any? do |email|
      email.to.include?(lecturer.email) &&
        /Your event has been approved/.match?(email.subject)
    end

    assert(email_deliveries.any? do |email|
      email.to.include?(lecturer.email) &&
      @new_event_email_regex.match?(email.subject)
    end)
    assert(email_deliveries.any? do |email|
      email.to.include?(lecturer.email) &&
      @approve_event_email_regex.match?(email.subject)
    end)
  end

  test 'creation email is sent to all users that take creation email' do
    lecturer = create(:user, user_type: :lecturer)
    event = create(:event, user: lecturer, approved: false)

    member = create(:user)
    member_not_accept_creation_email = create(:user, event_creation_email: false)

    assert_emails 3 do
      perform_enqueued_jobs do
        event.approved = true
        event.save!
      end
    end

    email_deliveries = ActionMailer::Base.deliveries
    assert(email_deliveries.any? do |email|
      email.to.include?(member.email) &&
      @new_event_email_regex.match?(email.subject)
    end)
    assert(email_deliveries.any? do |email|
      email.to.include?(lecturer.email) &&
      @approve_event_email_regex.match?(email.subject)
    end)
    refute(email_deliveries.any? do |email|
      email.to.include?(member_not_accept_creation_email.email)
    end)
  end
end
