# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User can sign in/up with facebook', '
  In order to use app
  As an authenticated or non-authenticated user
  I want to sign in/up with facebook
' do

  given(:user) { create(:user) }

  scenario 'User already has authorization' do
    user.authorizations.create(provider: mock_facebook_auth_hash.provider,
                               uid: mock_facebook_auth_hash.uid)

    visit new_user_session_path
    click_on 'Sign in with facebook'
    mock_facebook_auth_hash

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Вход в систему выполнен с учетной записью из Facebook.'
    expect(page).to have_link 'Выйти'
  end

  describe 'User has not authorization' do
    context 'user already exists' do
      scenario 'provider gives email'
      scenario 'provider does not give email'
    end

    context 'user does not exists' do
      scenario 'provider gives email'
      scenario 'provider does not give email'
    end
  end
end
