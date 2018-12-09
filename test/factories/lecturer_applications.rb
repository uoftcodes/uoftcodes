# frozen_string_literal: true

FactoryBot.define do
  factory :lecturer_application do
    association :user, factory: :user, user_type: :member
    resume { Base64.encode64(Faker::String.random) }
    interests { Faker::Lorem.sentence }
    additional_info { Faker::Lorem.sentence }
    student { true }
    approval_status { :pending }
  end
end
