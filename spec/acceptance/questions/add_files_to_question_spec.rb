# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User can add files to question', '
  In order to illustrate my question
  As an authenticated user
  I want to add files for question
' do

  given(:user) { create(:user) }

  scenario 'User tries to add files to question' do
    sign_in user
    visit new_question_path
    fill_in 'Заголовок', with: 'title'
    fill_in 'Ваш вопрос', with: 'body'
    attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Создать'

    expect(page).to have_content 'spec_helper.rb'
  end
end
