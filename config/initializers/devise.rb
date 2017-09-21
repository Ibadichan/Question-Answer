# frozen_string_literal: true

# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|
  config.secret_key = 'ce197774b488a4aafc1ea5ab61dcabda3056943c6d4d2f344a168d2b302c0b8
  cf8f760653153727f3d287df0c6883eb6313f6572063aaeb810fa30ab708337ad'

  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 11
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.omniauth :facebook, Rails.application.secrets.facebook_app_id,
                  Rails.application.secrets.facebook_app_secret
  config.omniauth :twitter, Rails.application.secrets.twitter_app_key,
                  Rails.application.secrets.twitter_app_secret
end
