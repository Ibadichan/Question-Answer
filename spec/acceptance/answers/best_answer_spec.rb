# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User can select the best answer of question', '
  In order to close question
  As an author of question
  I want to select best answer
' do

  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  describe 'Author of question tries to select best answer' do
    background do
      sign_in(author)

      visit question_path(question)

      within all('div[data-answer-id]').last do
        click_on 'Лучший ответ'
        wait_for_ajax
      end

      within all('div[data-answer-id]').first do
        expect(page).to have_content answers.last.body
      end
    end

    scenario 'author tries to select best answer', js: true do
    end

    scenario 'author tries to re-select best answer', js: true do
      within all('div[data-answer-id]').last do
        click_on 'Лучший ответ'
        wait_for_ajax
      end

      within all('div[data-answer-id]').first do
        expect(page).to have_content answers.first.body
      end
    end
  end

  scenario 'Non-Author of question tries to select best answer' do
    sign_in(non_author)

    visit question_path(question)

    within '.answers' do
      expect(page).to have_no_link 'Лучший ответ'
    end
  end

  scenario 'Guest tries to select best answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to have_no_link 'Лучший ответ'
    end
  end
end
