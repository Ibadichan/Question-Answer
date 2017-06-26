require 'rails_helper'

feature 'user can see all questions', %q{
  In order to be able to find the question
  As a guest or authenticated user
  I want to see all questions
} do

  scenario 'User tries to see all questions' do
    visit questions_path

    expect(page).to have_content('Все вопросы')
  end
end
