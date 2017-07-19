# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'Author can remove the file of his question', '
  In order to edit my question
  As an author of question
  I want to remove file
' do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:attachment) { create(:attachment) }

  background { question.attachments << attachment }

  scenario 'Author tries to remove file', js: true do
    sign_in author
    visit question_path(question)

    click_on 'Удалить файл'

    expect(page).to have_no_link attachment.file.identifier
  end

  scenario 'Non-author tries to remove file' do
    sign_in user
    visit question_path(question)

    expect(page).to have_no_link 'Удалить файл'
  end

  scenario 'Guest tries to remove file' do
    visit question_path(question)

    expect(page).to have_no_link 'Удалить файл'
  end
end
