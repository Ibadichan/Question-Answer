# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'Author tries to remove file of answer', '
  In order to edit my answer
  As an author of answer
  I want to remove file
' do

  given(:author) { create(:user) }
  given(:question) { create(:question) }
  given(:non_author) { create(:user) }
  given!(:answer) { create(:answer, user: author, question: question) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'Author tries to remove file of answer', js: true do
    sign_in author

    visit  question_path(question)

    within '.answers' do
      click_on 'Удалить файл'
      expect(page).to have_no_link attachment.file.identifier
    end
  end

  scenario 'Non-author of answer tries to remove file' do
    sign_in non_author

    visit question_path(question)

    within('.answers') { expect(page).to have_no_link 'Удалить файл' }
  end

  scenario 'Guest tries to remove file of answer' do
    visit  question_path(question)

    within('.answers') { expect(page).to have_no_link 'Удалить файл' }
  end
end
