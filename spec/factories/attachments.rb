# frozen_string_literal: true

FactoryGirl.define do
  factory :attachment do
    file File.open("#{Rails.root}/Gemfile")
    association :attachable
  end
end
