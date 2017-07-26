# frozen_string_literal: true

FactoryGirl.define do
  factory :vote do
    value { [1, -1].sample }
    user
    association :votable
  end
end
