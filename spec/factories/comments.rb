# frozen_string_literal: true

FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "my_comment_body#{n}" }
    association :commentable, factory: %i[answer question].sample
    factory :invalid_comment do
      body nil
      association :commentable, factory: %i[answer question].sample
    end
  end
end
