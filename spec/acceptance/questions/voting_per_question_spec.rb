# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User can vote for question', '
  In order to do rating
  As a non-author of question
  I want to vote
' do

  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Non-author tries to', js: true do
    background do
      sign_in non_author
      visit question_path(question)
    end

    scenario 'vote with for' do
      click_on 'За вопрос'
      expect(page).to have_content 'Рейтинг вопроса 1'
    end

    scenario 'vote with against' do
      click_on 'Против вопроса'
      expect(page).to have_content 'Рейтинг вопроса 0'
    end

    describe 'vote 2 times' do
      scenario 'with for' do
        click_on 'За вопрос'
        expect(page).to have_no_link 'За вопрос'
        expect(page).to have_no_link 'Против вопроса'
        page.reset! # если юзер перезагрузит page
        expect(page).to have_no_link 'За вопрос'
        expect(page).to have_no_link 'Против вопроса'
      end

      scenario 'with against' do
        click_on 'Против вопроса'
        expect(page).to have_no_link 'За вопрос'
        expect(page).to have_no_link 'Против вопроса'
        page.reset!
        expect(page).to have_no_link 'За вопрос'
        expect(page).to have_no_link 'Против вопроса'
      end
    end

    describe 're-vote' do
      scenario 'with for'
      scenario 'with against'
    end
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
