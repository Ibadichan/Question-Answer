# frozen_string_literal: true

FactoryGirl.define do
  factory :answer do
    body  'MyText'
    question
    factory :invalid_answer do
      body  nil
      question
    end
  end
end
