# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'active_model_serializers', '~> 0.9.3'
gem 'bcrypt', '~> 3.1.7'
gem 'bootstrap-social-rails'
gem 'cancancan'
gem 'capybara-email'
gem 'carrierwave'
gem 'cocoon'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'devise-i18n'
gem 'doorkeeper'
gem 'doorkeeper-i18n'
gem 'figaro'
gem 'font-awesome-rails'
gem 'gon'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'mysql2'
gem 'oj'
gem 'oj_mimic_json'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.1'
gem 'rails-controller-testing'
gem 'redis', '~> 3.0'
gem 'redis-rails'
gem 'remotipart'
gem 'require_all'
gem 'responders', '~> 2.0'
gem 'sass-rails', '~> 5.0'
gem 'sidekiq'
gem 'skim'
gem 'slim-rails'
gem 'sprockets', '>= 3.7.0'
gem 'therubyracer'
gem 'thinking-sphinx', '3.3.0'
gem 'thor', '0.19.4'
gem 'turbolinks', '~> 5'
gem 'twitter-bootstrap-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier', '>= 1.3.0'
gem 'unicorn'
gem 'whenever'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'capistrano', '~> 3.7', '>= 3.7.1', require: false
  gem 'capistrano-rails', '~> 1.2', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'database_cleaner'
  gem 'json_spec'
  gem 'launchy'
  gem 'shoulda-matchers',
      git: 'https://github.com/thoughtbot/shoulda-matchers.git',
      branch: 'rails-5'
end
