# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User can subscribe for question', '
  In order to get notifications
  As an Authenticated user
  I want to subscribe
' do

  given(:question) { create(:question) }
  given(:user)     { create(:user) }

  scenario 'Guest tries to subscribe' do
    visit question_path(question)
    within('.question-wrapper') { expect(page).to have_no_link 'Подписаться' }
  end

  scenario 'Authenticated user tries to subscribe', js: true do
    sign_in user

    visit question_path(question)
    within('.question-wrapper') { click_on 'Подписаться' }
    within('.question-wrapper') { expect(page).to have_no_link 'Подписаться' }
  end
end
