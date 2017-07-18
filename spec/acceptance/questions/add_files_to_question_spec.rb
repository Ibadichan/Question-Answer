# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'Add files to question', '
  In order to illustrate question
  As an authenticated user
  I want to add files to question
' do
  given(:user) { create(:user) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'User tries to add one file when asks the  question' do
    fill_in 'Заголовок', with: 'title'
    fill_in 'Ваш вопрос', with: 'body'
    attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Создать'

    expect(page).to have_link 'spec_helper.rb',
                              href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User adds a few files when asks the  question', js: true do
    fill_in 'Заголовок', with: 'title'
    fill_in 'Ваш вопрос', with: 'body'

    attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Еще один'

    within all('form#new_question .nested-fields').last do
      attach_file 'Файл', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Создать'

    expect(page).to have_link 'spec_helper.rb',
                              href: '/uploads/attachment/file/2/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb',
                              href: '/uploads/attachment/file/3/rails_helper.rb'
  end
end
