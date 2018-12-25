# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::String.random(6..12) }
    confirmed_at { Faker::Time.between(2.days.ago, Date.today) }
    confirmation_sent_at { Faker::Time.between(3.days.ago, 2.days.ago) }
    user_type { :member }
    event_registration_email { true }
    event_reminder_email { true }
    event_creation_email { true }
  end
end
