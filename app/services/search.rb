# frozen_string_literal: true

class Search
  CATEGORIES         = ['Вопросы', 'Ответы', 'Комментарии', 'Пользователи', 'Все категории'].freeze
  ENGLISH_CATEGORIES = ['Questions', 'Answers', 'Comments', 'Users', 'All Categories'].freeze

  def self.find_object(query, category)
    query = Riddle::Query.escape(query)
    return ThinkingSphinx.search query if category == 'Все категории'
    index = CATEGORIES.index(category)
    english_category = ENGLISH_CATEGORIES[index]
    english_category.classify.constantize.search(query)
  end
end
