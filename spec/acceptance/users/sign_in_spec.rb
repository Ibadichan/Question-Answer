# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User log in', '
  In order to be able to ask question
  As an user
  I want to be able log in
' do

  given(:user) { create(:user) }

  scenario 'Registered user tries to log in' do
    sign_in(user)

    expect(page).to have_content 'Вход в систему выполнен.'
    expect(current_path).to eq root_path
  end

  scenario 'Not-registered user tries to log in' do
    visit new_user_session_path

    fill_in 'Email', with: 'wrong@mail.ru'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти'

    expect(page).to have_content 'Неверный адрес эл. почты или пароль.'
    expect(current_path).to eq new_user_session_path
  end
end
