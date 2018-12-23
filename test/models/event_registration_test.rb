# frozen_string_literal: true

require 'test_helper'

class EventRegistrationTest < ActiveSupport::TestCase
  setup do
    @member = create(:user, user_type: :member)
    @non_approved_event = create(:event, approved: false)
  end

  test '#event_must_be_approved validation' do
    event_registration = EventRegistration.new(user: @member, event: @non_approved_event)

    refute event_registration.save
  end
end
