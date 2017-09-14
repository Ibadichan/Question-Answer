# frozen_string_literal: true

require 'acceptance/acceptance_helper'

feature 'User can search', '
  In order to get answer
  As an authenticated user or guest
  I want to search
' do

  given!(:question) { create(:question) }
  given!(:answer)   { create(:answer, question: question) }
  given!(:comment)  { create(:comment, commentable: question) }
  given!(:user)     { create(:user) }

  background do
    index
    visit root_path
    click_on 'Расширенный поиск'
  end

  scenario 'User tries to search only questions', js: true do
    fill_in :query, with: question.title
    select 'Вопросы', from: :category
    click_on 'Поиск'
    expect(page).to have_link(question.title)
  end

  scenario 'User tries to search only answers', js: true do
    fill_in :query, with: answer.body
    select 'Ответы', from: :category
    click_on 'Поиск'
    expect(page).to have_content(answer.body)
    expect(page).to have_link(question.title)
  end

  scenario 'User tries to search only comments', js: true do
    fill_in :query, with: comment.body
    select 'Комментарии', from: :category
    click_on 'Поиск'
    expect(page).to have_content(comment.body)
    expect(page).to have_link(question.title)
  end

  scenario 'User tries to search only users', js: true do
    fill_in :query, with: user.name
    select 'Пользователи', from: :category
    click_on 'Поиск'
    expect(page).to have_content(user.name)
    expect(page).to have_content(user.email)
  end

  describe 'User searches object and selects all categories' do
    given!(:question) { create(:question, title: 'PAROLE') }
    given!(:answer)   { create(:answer, question: question, body: 'PAROLE') }
    given!(:comment)  { create(:comment, commentable: question, body: 'PAROLE') }
    given!(:user)     { create(:user, name: 'PAROLE') }

    scenario 'User tries to search object with all categories', js: true do
      fill_in :query, with: 'PAROLE'
      select 'Все категории', from: :category
      click_on 'Поиск'
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).to have_content(comment.body)
      expect(page).to have_content(answer.body)
      expect(page).to have_link(question.title)
    end
  end
end
