# frozen_string_literal: true

class Search
  CATEGORIES = ['Вопросы', 'Ответы', 'Комментарии', 'Пользователи', 'Все категории'].freeze

  def self.find_object(query, category)
    case category
    when 'Вопросы'
      Question.search(query)
    when 'Ответы'
      Answer.search query
    when 'Комментарии'
      Comment.search query
    when 'Пользователи'
      User.search query
    when 'Все категории'
      ThinkingSphinx.search query
    end
  end
end
