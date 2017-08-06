# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User can vote for answer', '
  In order to do rating
  As a non-author of answer
  I want to vote
' do
  given(:non_author) { create(:user) }
  given(:author)     { create(:user) }
  given(:question)   { create(:question) }
  given!(:answer)    { create(:answer, user: author, question: question) }

  describe 'Non-author tries', js: true do
    background do
      sign_in non_author
      visit question_path(question)
    end

    scenario 'to vote with for' do
      click_on 'За ответ'
      expect(page).to have_content 'Рейтинг ответа 1'
    end

    scenario 'to vote with against' do
      click_on 'Против ответа'
      expect(page).to have_content 'Рейтинг ответа -1'
    end

    describe 'to vote 2 times' do
      scenario 'with for' do
        click_on 'За ответ'
        expect(page).to have_no_link 'За ответ'
        expect(page).to have_no_link 'Против ответа'
        page.reset!
        expect(page).to have_no_link 'За ответ'
        expect(page).to have_no_link 'Против ответа'
      end

      scenario 'with against' do
        click_on 'Против ответа'
        expect(page).to have_no_link 'За ответ'
        expect(page).to have_no_link 'Против ответа'
        page.reset!
        expect(page).to have_no_link 'За ответ'
        expect(page).to have_no_link 'Против ответа'
      end
    end

    describe 'to re-vote' do
      scenario 'with for' do
        click_on 'За ответ'
        within('.answers') { click_on 'Переголосовать' }
        expect(page).to have_content 'Рейтинг ответа 0'
        expect(page).to have_link 'Против ответа'
        click_on 'За ответ'
        expect(page).to have_content 'Рейтинг ответа 1'
      end

      scenario 'with against' do
        click_on 'Против ответа'
        within('.answers') { click_on 'Переголосовать' }
        expect(page).to have_content 'Рейтинг ответа 0'
        expect(page).to have_link 'За ответ'
        click_on 'Против ответа'
        expect(page).to have_content 'Рейтинг ответа -1'
      end
    end
  end

  scenario 'Author tries to vote' do
    sign_in author
    visit question_path(question)

    expect(page).to have_no_content 'За ответ'
    expect(page).to have_no_content 'Против ответа'
  end

  scenario 'Guest tries to vote' do
    visit question_path(question)

    expect(page).to have_no_content 'За ответ'
    expect(page).to have_no_content 'Против ответа'
  end
end
