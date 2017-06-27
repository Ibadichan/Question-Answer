# frozen_string_literal: true

require 'rails_helper'

feature 'user can see all questions', '
  In order to be able to find the question
  As a guest or authenticated user
  I want to see all questions
' do

  given(:user) {create(:user)}
  given!(:question) { create(:question) }

  scenario 'Authenticated user tries to see all questions' do
    sign_in(user)

    visit questions_path

    expect(page).to have_content('Все вопросы')
    expect(page).to have_link(question.title)
  end

  scenario 'Guest tries to see all questions' do
    visit questions_path

    expect(page).to have_content('Все вопросы')
    expect(page).to have_link(question.title)
  end
end
