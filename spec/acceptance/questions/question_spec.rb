# frozen_string_literal: true

require 'rails_helper'

feature 'User can see the question', '
  In order to create the answer
  As a guest or authenticated user
  I want to see question
' do

  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'Author tries to see question' do
    sign_in(author)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end

  scenario 'Non-authenticated user tries to see question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
