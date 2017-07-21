# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User tries to edit answer', '
  In order to fix errors
  As an author of answer
  I want to edit answer
' do

  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: author, question: question) }

  describe 'Author tries to edit answer' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'with valid attributes', js: true do
      within '.answer-wrapper' do
        click_on 'Редактировать'
        fill_in 'Ваш ответ', with: 'new answer'
        click_on 'редактировать'
        expect(page).to_not have_selector 'textarea'
      end

      within('.answers') { expect(page).to have_content 'new answer' }
    end

    scenario 'with invalid attributes', js: true do
      within '.answer-wrapper' do
        click_on 'Редактировать'
        fill_in 'Ваш ответ', with: ''
        click_on 'редактировать'
        wait_for_ajax
        expect(page).to have_content 'Тело ответа не может быть пустым'
      end
    end
  end

  scenario 'Non author tries to edit answer' do
    sign_in(non_author)

    visit question_path(question)

    within('.answer-wrapper') { expect(page).to have_no_link 'Редактировать' }
  end

  scenario 'Guest tries to edit answer' do
    visit question_path(question)

    within('.answer-wrapper') { expect(page).to have_no_link 'Редактировать' }
  end
end
