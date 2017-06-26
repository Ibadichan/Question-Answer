require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) {create(:user)}

  scenario 'Authenticated user tries to ask question' do
    sign_in(user)

    visit questions_path

    click_on 'Задать вопрос'
    fill_in 'Title', with: 'my title'
    fill_in 'Body', with: 'my body'
    click_on 'Создать'

    expect(page).to have_content 'Вопрос успешно создан'
    expect(current_path).to eq question_path(Question.last)
    expect(page).to have_content 'my body'
    expect(page).to have_content 'my title'
  end

  scenario 'Not-authenticated user tries to ask question' do
    visit questions_path
    click_on 'Задать вопрос'

    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
  end
end
