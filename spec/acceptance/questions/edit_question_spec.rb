require 'acceptance/acceptance_helper'


feature 'User can edit question', '
  In order fix error
  As an author of question
  I want to edit question
' do

  given(:author) {create(:user)}
  given(:non_author) {create(:user)}
  given(:question) {create(:question, user: author)}

  scenario 'Author tries to edit question' do
    sign_in(author)

    visit question_path(question)
    click_on 'Редактировать вопрос'

    expect(current_path).to eq edit_question_path(question)

    fill_in 'Заголовок', with: 'Мой заголовок'
    fill_in 'Вопрос', with: 'мой вопрос'
    click_on 'Редактировать'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Мой заголовок'
    expect(page).to have_content 'мой вопрос'
    expect(page).to have_content 'Ваш вопрос отредактирован'
  end

  scenario 'Non-author tries to edit question' do
    sign_in(non_author)

    visit question_path(question)

    expect(page).to have_no_link 'Редактировать вопрос'
  end

  scenario 'Guest tries to edit question' do
    visit question_path(question)

    expect(page).to have_no_link 'Редактировать вопрос'
  end
end
