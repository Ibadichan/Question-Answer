# frozen_string_literal: true

FactoryGirl.define do
  factory :question do
    title 'MyString'
    body  'MyText'
    user
    factory :invalid_question do
      title nil
      body nil
      user
    end
  end
end
