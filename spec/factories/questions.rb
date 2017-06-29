# frozen_string_literal: true

FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "MyString #{n}" }
    sequence(:body) { |n| "MyText #{n}" }
    user
    factory :invalid_question do
      title nil
      body nil
      user nil
    end
  end
end
