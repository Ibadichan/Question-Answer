# frozen_string_literal: true

require 'rails_helper'

feature 'User registers', '
  In order to be able to  use the system
  As a guest
  I want to register
' do

  scenario 'Guest tries to register' do
    visit new_user_registration_path

    fill_in 'Email', with: 'test@mail.ru'
    fill_in 'Пароль', with: '123456'
    fill_in 'Подтверждение пароля', with: '123456'
    click_on 'Sign up'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Добро пожаловать! Вы успешно зарегистрировались.'
  end
end
