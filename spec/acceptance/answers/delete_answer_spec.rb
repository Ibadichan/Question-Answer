require 'rails_helper'

feature 'User deletes answer', %q{
  In order to destroy answer
  As an author of answer
  I want to delete  the answer
} do

  given(:user1) {create(:user)}
  given(:user2) {create(:user)}
  given(:question) {create(:question)}
  given(:answer) {create(:answer, user: user1, question: question)}

  before do
    question
    answer
  end

  scenario 'Author tries to delete own answer' do
    sign_in(user1)

    visit question_path(question)
    click_on 'Удалить ответ'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Ваш ответ удален'
  end

  scenario 'Authenticated user tries to delete another answer' do
    sign_in(user2)

    visit question_path(question)

    expect(page).to have_no_content 'Удалить ответ'
  end

  scenario 'Not-authenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to have_no_content 'Удалить ответ'
  end
end
