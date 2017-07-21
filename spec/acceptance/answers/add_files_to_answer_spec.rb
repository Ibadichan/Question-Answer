# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User can add files to answer', '
  In order to illustrate my answer
  As an authenticated user
  I want add files to answer
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User tries to add one file to answer', js: true do
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
