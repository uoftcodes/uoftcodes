# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :location, :description, :start_time, :end_time
  validate :end_time_cannot_be_before_start_time, :user_must_be_a_lecturer

  def end_time_cannot_be_before_start_time
    errors.add(:end_time, 'cannot be before start time') if end_time && start_time && end_time <= start_time
  end

  def user_must_be_a_lecturer
    errors.add(:user, 'must be a lecturer') unless user.nil? || user.like_lecturer?
  end

  def formatted_time_range
    # If in the same year as the current time, omit the year
    if end_time.year == Time.now.year
      # If the start and end are on the same day, omit the date on end time
      if start_time.to_date == end_time.to_date
        start_time.strftime('%A, %-d %b %-l:%M %p') + ' - ' + end_time.strftime('%-l:%M %p')
      else
        start_time.strftime('%A, %-d %b %-l:%M %p') + ' - ' + end_time.strftime('%A, %-d %b %-l:%M %p')
      end
    elsif start_time.to_date == end_time.to_date # If the start and end are on the same day, omit the date on end time
      start_time.strftime('%A, %-d %b %Y %-l:%M %p') + ' - ' + end_time.strftime('%-l:%M %p')
    else
      start_time.strftime('%A, %-d %b %Y %-l:%M %p') + ' - ' + end_time.strftime('%A, %-d %b %Y %-l:%M %p')
    end
  end

  def build_error_message
    'You have errors: ' + @event.errors.full_messages.map(&:downcase).join(', ')
  end
end
