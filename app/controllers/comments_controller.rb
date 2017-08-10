# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :find_commentable
  after_action :publish_comment

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment
    else
      render json: @comment.errors.messages, status: :unprocessable_entity
    end
  end

  private

  def publish_comment
    return if @comment.errors.any?
    type_of_commentable = @commentable.class.name.underscore
    ActionCable.server.broadcast(
      "#{@commentable.id}_#{type_of_commentable}_channel", comment: @comment, user: @comment.user
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
