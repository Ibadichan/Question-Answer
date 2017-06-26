require 'rails_helper'

feature 'User deletes question', %q{
  In order to close the question
  As an author of question
  I want to delete question
} do

  given(:user1) {create(:user)}
  given(:user2) {create(:user)}
  given(:question) {create(:question, user: user1)}

  before {question}

  scenario 'Authenticated user tries to delete own question' do
    sign_in(user1)

    visit questions_path
    click_on question.title
    click_on 'Удалить вопрос'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Вопрос удален'
  end

  scenario 'Authenticated user tries to delete another question' do
    sign_in(user2)

    visit questions_path
    click_on question.title

    expect(page).to have_no_content 'Удалить вопрос'
  end

  scenario 'Not-authenticated user tries to delete question' do
    visit questions_path

    click_on question.title

    expect(page).to have_no_content 'Удалить вопрос'
  end
end
