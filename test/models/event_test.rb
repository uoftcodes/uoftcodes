# frozen_string_literal: true

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    @event = events(:approved_lecture)
  end

  test 'validation fails for a event with end time before start time' do
    @event.start_time = Time.zone.now - 1.hour
    @event.end_time = Time.zone.now - 5.hour

    assert_raises ActiveRecord::RecordInvalid do
      @event.save!
    end
  end

  test 'validation fails for a event where the user is not a lecturer' do
    @event.user = users(:member)

    assert_raises ActiveRecord::RecordInvalid do
      @event.save!
    end
  end
end
