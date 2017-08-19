# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user_name_#{n}" }
    sequence(:email) { |n| "user#{n}@mail.com" }
    password '123456'
    password_confirmation '123456'
    confirmed_at Time.now - 1.days
  end
end
