# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User can add comment to question', '
  In order to evaluate the question
  As an authenticated user
  I want to add comment
' do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user tries to add comment', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid attributes' do
      within '.question-wrapper' do
        click_on 'Комментарии'
        fill_in 'Ваш комментарий', with: 'My comment'
        click_on 'Комментировать'
        expect(page).to have_content 'My comment'
      end
    end

    scenario 'with invalid attributes' do
      within '.question-wrapper' do
        click_on 'Комментарии'
        fill_in 'Ваш комментарий', with: ''
        click_on 'Комментировать'
        expect(page).to have_content 'Тело комментария не может быть пустым'
      end
    end
  end

  scenario 'Guest tries to add comment' do
    visit question_path(question)

    expect(page).to have_no_link 'Комментировать вопрос'
  end
end
