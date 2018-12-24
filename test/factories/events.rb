# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    association :user, factory: :user, user_type: :lecturer
    title { Faker::Lorem.sentence }
    location { Faker::Lorem.characters(5) }
    description { Faker::Lorem.paragraph }
    start_time { Faker::Time.between(1.hour.from_now, 2.hours.from_now, :between) }
    end_time { Faker::Time.between(3.hours.from_now, 4.hours.from_now, :between) }
    approved { true }
  end
end
