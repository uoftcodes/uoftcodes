# frozen_string_literal: true

FactoryBot.define do
  factory :event_registration do
    association :user, factory: :user, user_type: :member
    association :event, factory: :event, approved: true
  end
end
