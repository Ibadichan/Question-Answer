# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User can add files to question', '
  In order to illustrate my question
  As an authenticated user
  I want to add files for question
' do

  given(:user) { create(:user) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'User tries to add one file to question', js: true do
    fill_in 'Заголовок', with: 'title'
    fill_in 'Ваш вопрос', with: 'body'

    click_on 'Добавить файл'

    within('.nested-fields') { find('input[type="file"]').set("#{Rails.root}/Rakefile") }

    click_on 'Создать'

    within '.attachments-of-question' do
      expect(page).to have_link 'Rakefile',
                                href: "#{Rails.root}/spec/support/uploads/attachment/file/1/Rakefile"
    end
  end

  scenario 'User tries to add a few files to question', js: true do
    fill_in 'Заголовок', with: 'title 1'
    fill_in 'Ваш вопрос', with: 'body 1'

    click_on 'Добавить файл'

    within all('.nested-fields').first do
      find('input[type="file"]').set("#{Rails.root}/Gemfile")
    end

    click_on 'Добавить файл'

    within all('.nested-fields').last do
      find('input[type="file"]').set("#{Rails.root}/config.ru")
    end

    click_on 'Создать'

    within '.attachments-of-question' do
      expect(page).to have_link 'Gemfile',
                                href: "#{Rails.root}/spec/support/uploads/attachment/file/1/Gemfile"
      expect(page).to have_link 'config.ru',
                                href: "#{Rails.root}/spec/support/uploads/attachment/file/2/config.ru"
    end
  end
end
