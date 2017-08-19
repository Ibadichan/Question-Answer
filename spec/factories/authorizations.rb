# frozen_string_literal: true

FactoryGirl.define do
  factory :authorization do
    provider 'MyString'
    uid 'MyString'
    user
  end
end
