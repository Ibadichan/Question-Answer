# frozen_string_literal: true

FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do
    sequence(:name) { |n| "Test_#{n}" }
    redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
    uid '123456789'
    secret '987654321'
  end
end
