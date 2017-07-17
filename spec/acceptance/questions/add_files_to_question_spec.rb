# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'Add files to question', '
  In order to illustrate question
  As an authenticated user
  I want to add files to question
' do
  given(:user) { create(:user) }

  scenario 'Author tries to add file when asks the  question' do
    sign_in user
    visit new_question_path

    fill_in 'Заголовок', with: 'title'
    fill_in 'Ваш вопрос', with: 'body'
    attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Создать'

    expect(page).to have_link 'spec_helper.rb',
                              href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end
