# frozen_string_literal: true

ThinkingSphinx::Index.define :answer, with: :active_record do
  # fields

  indexes body
  indexes user.name, as: :author, sortable: true

  # attributes

  has user_id, created_at, updated_at, question_id, best
end
