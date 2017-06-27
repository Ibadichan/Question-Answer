# frozen_string_literal: true

FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "MyText #{n}" }
    user
    question
    factory :invalid_answer do
      body  nil
      user
      question
    end
  end
end
