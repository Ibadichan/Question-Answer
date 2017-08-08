# frozen_string_literal: true

FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "my_comment_body#{n}" }
    association :commentable
    factory :invalid_comment do
      body nil
      association :commentable
    end
  end
end
