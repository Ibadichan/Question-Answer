# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User can vote for question', '
  In order to do rating
  As a non-author of question
  I want to vote
' do

  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:non_author) { create(:user) }

  describe 'Non-author tries to vote', js: true do
    background do
      sign_in non_author
      visit question_path(question)
    end

    scenario 'with for' do
      within '.question-wrapper' do
        click_on 'За вопрос'
        expect(page).to have_content 'Рейтинг вопроса 1'
      end
    end

    scenario 'with against' do
      within '.question-wrapper' do
        click_on 'За вопрос'
        wait_for_ajax
        expect(page).to have_content 'Рейтинг вопроса 2'
      end
    end
  end

  describe 'Non-author tries to vote 2 times' do
    scenario 'with for' do
      sign_in non_author
      visit question_path(question)
      save_and_open_page
    end
    scenario 'with against'
  end

  describe 'Non-author tries to re-vote' do
    scenario 'with for'
    scenario 'with against'
  end

  scenario 'Author tries to vote' do
    sign_in author
    visit question_path(question)

    expect(page).to have_no_link 'За вопрос'
    expect(page).to have_no_link 'Против вопроса'
  end

  scenario 'Guest tries to vote' do
    visit question_path(question)

    expect(page).to have_no_link 'За вопрос'
    expect(page).to have_no_link 'Против вопроса'
  end
end
