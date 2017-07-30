# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User can to edit question', '
  In order to fix mistake
  As an author of question
  I want to edit question
' do

  given(:author)     { create(:user) }
  given(:non_author) { create(:user) }
  given(:question)   { create(:question, user: author) }

  describe 'Author tries to edit question', js: true do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'with attributes' do
      click_on 'Редактировать'

      within '.edit_question' do
        fill_in 'Заголовок', with: 'Новый заголовок'
        fill_in 'Ваш вопрос', with: 'Новое тело'
        click_on 'Изменить'
        wait_for_ajax
      end

      within '.question-show' do
        expect(page).to have_content 'Новый заголовок'
        expect(page).to have_content 'Новое тело'
      end

      expect(page).to_not have_css('div.question_edit')
    end

    scenario 'without attributes' do
      click_on 'Редактировать'

      within '.edit_question' do
        fill_in 'Заголовок', with: ''
        fill_in 'Ваш вопрос', with: ''
        click_on 'Изменить'
      end

      within '.question-errors' do
        expect(page).to have_content 'Тело вопроса не может быть пустым'
        expect(page).to have_content 'Заголовок вопроса не может быть пустым'
      end
    end
  end

  scenario 'Non author tries to edit question' do
    sign_in(non_author)

    visit question_path(question)

    expect(page).to have_no_link 'Редактировать'
  end

  scenario 'Guest tries to edit question' do
    visit question_path(question)

    expect(page).to have_no_link 'Редактировать'
  end
end
