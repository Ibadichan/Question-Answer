# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'Add files to answer', '
  In order to illustrate my answer
  As an authenticated user
  I want to add file to answer
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in user

    visit question_path(question)
  end

  scenario 'User tries to add one file to answer', js: true do
    fill_in 'Ваш ответ', with: 'text'
    attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'ответить'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb',
                                href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User tries to add a few files to answer', js: true do
    fill_in 'Ваш ответ', with: 'ваня'

    attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Еще один'

    within all('form#new_answer .nested-fields').last do
      attach_file 'Файл', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'ответить'

    expect(page).to have_link 'spec_helper.rb',
                              href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb',
                              href: '/uploads/attachment/file/2/rails_helper.rb'
  end
end
