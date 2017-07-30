# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User can add files to answer', '
  In order to illustrate my answer
  As an authenticated user
  I want add files to answer
' do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'User tries to add one file to answer', js: true do
    fill_in 'Ваш ответ', with: 'text'

    click_on 'Добавить файл'

    within('.new_answer .nested-fields') { find('input[type="file"]').set("#{Rails.root}/.rspec") }

    click_on 'ответить'

    within '.answers' do
      expect(page).to have_link '.rspec',
                                href: "#{Rails.root}/spec/support/uploads/attachment/file/1/.rspec"
    end
  end

  scenario 'User tries to add a few files to answer', js: true do
    fill_in 'Ваш ответ', with: 'text text'

    click_on 'Добавить файл'

    within all('.new_answer .nested-fields').first do
      find('input[type="file"]').set("#{Rails.root}/Gemfile")
    end

    click_on 'Добавить файл'

    within all('.new_answer .nested-fields').last do
      find('input[type="file"]').set("#{Rails.root}/.rspec")
    end

    click_on 'ответить'

    within '.answers' do
      expect(page).to have_link 'Gemfile',
                                href: "#{Rails.root}/spec/support/uploads/attachment/file/1/Gemfile"
      expect(page).to have_link '.rspec',
                                href: "#{Rails.root}/spec/support/uploads/attachment/file/2/.rspec"
    end
  end
end
