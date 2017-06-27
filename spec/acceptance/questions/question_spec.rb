require 'rails_helper'

feature 'User can see the question', %q{
  In order to create the answer
  As a guest or authenticated user
  I want to see question
} do

  given(:author) {create(:user)}
  given!(:question) {create(:question, user: author)}

  scenario 'Author tries to see question' do
    sign_in(author)
    show_question(question)
  end

  scenario 'Non-authenticated user tries to see question' do
    show_question(question)
  end

  scenario 'Non-author of the question tries to see question' do
    show_question(question)
  end
end
