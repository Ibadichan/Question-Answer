# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'Create question', '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
' do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries to ask question', js: true do
    Capybara.using_session('guest') { visit questions_path }

    Capybara.using_session('user') do
      sign_in(user)

      visit questions_path
      click_on 'Задать вопрос'
      fill_in 'Заголовок', with: 'my title'
      fill_in 'Ваш вопрос', with: 'my body'
      click_on 'Создать'

      expect(page).to have_content 'Вопрос успешно создан'
      expect(current_path).to eq question_path(Question.last)

      within '.question-show' do
        expect(page).to have_content 'my body'
        expect(page).to have_content 'my title'
      end
    end

    Capybara.using_session('guest') do
      within('.questions-list') { expect(page).to have_link 'my title' }
    end
  end

  scenario 'Authenticated user tries to ask  invalid question' do
    sign_in(user)

    visit questions_path
    click_on 'Задать вопрос'
    fill_in 'Заголовок', with: ''
    fill_in 'Ваш вопрос', with: ''
    click_on 'Создать'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Заголовок вопроса не может быть пустым'
    expect(page).to have_content 'Тело вопроса не может быть пустым'
  end

  scenario 'Not-authenticated user tries to ask question' do
    visit questions_path
    click_on 'Задать вопрос'

    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
  end
end
