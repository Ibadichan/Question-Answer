# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User can unsubscribe from question', '
  In order to stop get notifications
  As an authenticated user
  I want to unsubscribe
' do

  given(:question) { create(:question) }
  given(:user)     { create(:user) }

  describe 'user tries to unsubscribe from question' do
    before { sign_in user }

    scenario 'subscribed user', js: true do
      user.subscriptions.create(question: question)

      visit question_path(question)

      within '.question-wrapper' do
        click_on 'Отписаться'
        expect(page).to have_no_link 'Отписаться'
        expect(page).to have_link 'Подписаться'
      end
    end

    scenario 'non-subscribed user' do
      visit question_path(question)
      within('.question-wrapper') { expect(page).to have_no_link 'Отписаться' }
    end
  end
end
