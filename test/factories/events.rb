# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    association :user, factory: :user, user_type: :lecturer
    title { Faker::Lorem.sentence }
    location { Faker::String.random }
    description { Faker::Lorem.paragraph }
    start_time { Faker::Time.between(1.day.from_now, 2.days.from_now) }
    end_time { Faker::Time.between(2.days.from_now, 3.days.from_now) }
    approved { true }
  end
end
