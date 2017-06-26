require 'rails_helper'

feature 'user creates answer', %q{
  In order to answer the question
  As an authenticated user
  I want to create answer
} do

  given(:user) {create(:user)}
  given(:question) {create(:question)}

  before {question}

  scenario 'Authenticated user tries to create answer' do
    sign_in(user)

    visit questions_path
    click_on  question.title

    fill_in 'Body', with: 'text text'
    click_on 'ответить'

    expect(page).to have_content 'Ответ успешно создан'
  end

  scenario 'Not authenticated user tries to create answer' do
    visit questions_path
    click_on  question.title

    fill_in 'Body', with: 'text text'
    click_on 'ответить'

    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
  end
end
