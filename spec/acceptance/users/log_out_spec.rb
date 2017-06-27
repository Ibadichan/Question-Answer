# frozen_string_literal: true

require 'rails_helper'

feature 'User log out', '
  In order to be able finish the session
  As an authenticated user
  I want to log out
' do

  given(:user) { create(:user) }

  scenario 'User tries to log out' do
    sign_in(user)

    click_on 'Выйти'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Выход из системы выполнен.'
  end

  scenario 'Guest to log out' do
    visit root_path
    expect(page).to have_no_link 'Выйти'
  end
end
