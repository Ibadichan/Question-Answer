# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'Author can remove file of question', '
  In order to edit question
  As an author of question
  I want to remove file
' do

  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:attachment) { create(:attachment, attachable: question) }

  scenario 'Non-author tries to remove file of question' do
    sign_in non_author

    visit question_path(question)

    within('.attachments-of-question') { expect(page).to have_no_link 'Удалить файл' }
  end

  scenario 'Guest tries to remove file of question' do
    visit question_path(question)

    within('.attachments-of-question') { expect(page).to have_no_link 'Удалить файл' }
  end

  scenario 'Author tries to remove file of question', js: true do
    sign_in author

    visit question_path(question)

    click_on 'Удалить файл'
    wait_for_ajax

    expect(page).to have_no_link attachment.file.identifier
  end
end
