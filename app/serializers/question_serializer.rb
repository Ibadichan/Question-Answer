# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :user_id, :short_title
  has_many :answers, :comments, :attachments

  def short_title
    object.title.truncate(10)
  end
end
