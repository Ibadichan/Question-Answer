# frozen_string_literal: true

FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "MyAnswerText #{n}" }
    user
    question
    best false
    factory :invalid_answer do
      body  nil
      user nil
      question nil
      best nil
    end
    factory :best_answer do
      sequence(:body) { |n| "MyAnswerText #{n}" }
      user
      question
      best true
    end
  end
end
