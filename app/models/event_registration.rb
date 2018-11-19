# frozen_string_literal: true

class EventRegistration < ApplicationRecord
  belongs_to :events
  belongs_to :user
end
