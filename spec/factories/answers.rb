# frozen_string_literal: true

FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "MyAnswerText #{n}" }
    user
    question
    factory :invalid_answer do
      body  nil
      user nil
      question nil
    end
  end
end
