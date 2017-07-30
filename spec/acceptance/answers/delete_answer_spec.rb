# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User deletes answer', '
  In order to destroy answer
  As an author of answer
  I want to delete  the answer
' do

  given(:author)     { create(:user) }
  given(:non_author) { create(:user) }
  given(:question)   { create(:question) }
  given!(:answer)    { create(:answer, question: question, user: author) }

  scenario 'Author tries to delete own answer', js: true do
    sign_in(author)

    visit question_path(question)
    click_on 'Удалить ответ'
    wait_for_ajax
    expect(current_path).to eq question_path(question)
    expect(page).to have_no_content answer.body
  end

  scenario 'Authenticated user tries to delete another answer' do
    sign_in(non_author)

    visit question_path(question)

    expect(page).to have_no_link 'Удалить ответ'
  end

  scenario 'Not-authenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to have_no_link 'Удалить ответ'
  end
end
