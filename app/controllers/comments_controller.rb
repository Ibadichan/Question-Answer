# frozen_string_literal: true

class CommentsController < ApplicationController
  authorize_resource
  before_action :find_commentable
  after_action  :publish_comment

  def create
    @comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id))
    respond_with @comment, json: @comment
  end

  private

  def publish_comment
    return if @comment.errors.any?
    question_id = @commentable.try(:question_id) || @commentable.id
    ActionCable.server.broadcast(
      "#{question_id}_comments_channel", comment: @comment, author: @comment.user
    )
  end

  def find_commentable
    klass = [Answer, Question].detect { |c| params["#{c.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
