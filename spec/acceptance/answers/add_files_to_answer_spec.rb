require 'acceptance/acceptance_helper'

feature 'Add files to answer', '
  In order to illustrate my answer
  As an authenticated user
  I want to add file to answer
' do

  given(:user) {create(:user)}
  given(:question) {create(:question)}

  scenario 'Author tries to add file to answer' do
    sign_in user

    visit question_path(question)

    fill_in 'Ваш ответ', with: 'text'
    attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'ответить'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb',
                                href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end
