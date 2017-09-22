# frozen_string_literal: true

# config valid only for current version of Capistrano
lock '3.9.1'

# If you want to restart using `touch tmp/restart.txt`, add this to your config/deploy.rb:
set :passenger_restart_with_touch, true

set :application, 'question-answer'
set :repo_url, 'git@github.com:Ibadichan/Question-Answer.git'

set :deploy_to, '/home/deployer/question-answer'
set :sidekiq_queue, %w[default mailers]

append :linked_files, 'config/database.yml', 'config/secrets.yml', 'config/thinking_sphinx.yml'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets',
       'vendor/bundle', 'public/system', 'public/uploads'
