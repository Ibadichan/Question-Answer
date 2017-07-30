# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'user creates answer', '
  In order to answer the question
  As an authenticated user
  I want to create answer
' do

  given!(:user)     { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user tries to create answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Ваш ответ', with: 'text text'
    click_on 'ответить'

    within '.answers' do
      expect(page).to have_content 'text text'
    end
  end

  scenario 'Authenticated user tries to create invalid answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Ваш ответ', with: ''
    click_on 'ответить'
    expect(page).to have_content 'Тело ответа не может быть пустым'
  end

  scenario 'Not authenticated user tries to create answer' do
    visit question_path(question)
    fill_in 'Ваш ответ', with: 'text text'
    click_on 'ответить'

    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
  end
end
