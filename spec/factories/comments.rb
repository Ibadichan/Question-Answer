# frozen_string_literal: true

FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "my_comment_body#{n}" }
    commentable factory: %i[answer question].sample
    user
    factory :invalid_comment do
      body nil
      commentable nil
      user nil
    end
  end
end
