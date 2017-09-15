# frozen_string_literal: true

class Search
  CATEGORIES = {
    questions: 'Вопросы',
    answers: 'Ответы',
    comments: 'Комментарии',
    users: 'Пользователи',
    all_categories: 'Все категории'
  }.freeze

  def self.find_object(query, category)
    query = Riddle::Query.escape(query)
    return ThinkingSphinx.search query if category == 'all_categories'
    category.classify.constantize.search(query)
  end
end
