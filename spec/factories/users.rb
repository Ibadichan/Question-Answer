# frozen_string_literal: true

FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.hbs.com"
  end

  factory :user do
    sequence(:name) { |n| "user_name_#{n}" }
    email
    password '123456'
    password_confirmation '123456'
  end
end
