# frozen_string_literal: true

FactoryGirl.define do
  factory :attachment do
    file File.open("#{Rails.root}/spec/spec_helper.rb")
    association :attachable
  end
end
