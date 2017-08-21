# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User can sign in/up with twitter', '
  In order to use app
  As an authenticated user or guest
  I want to sign in/up with twitter
' do

  given(:user) { create(:user) }

  scenario 'User has authorization, and tries to sign in' do
    user.authorizations.create(provider: mock_twitter_auth_hash.provider, uid: mock_twitter_auth_hash.uid)

    visit new_user_session_path
    click_on 'Sign in with twitter'
    mock_twitter_auth_hash

    expect(current_path).to eq root_path
    expect(page).to have_content 'Вход в систему выполнен с учетной записью из Twitter.'
  end

  scenario 'User tries to register with twitter' do
    visit new_user_session_path
    click_on 'Sign in with twitter'
    mock_twitter_auth_hash

    expect(page).to have_content 'Пожалуйста, укажите в поле ваш email,
                                          на него придет письмо для подтверждения вашего аккаунта'

    fill_in 'Email', with: 'new@mail.com'
    click_on 'Отправить'

    open_email('new@mail.com')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Ваш адрес эл. почты успешно подтвержден.'
    click_on 'Sign in with twitter'
    expect(page).to have_content 'Вход в систему выполнен с учетной записью из Twitter.'
  end
end
