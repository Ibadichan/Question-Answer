# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :set_answer,       only: %i[destroy update best]
  before_action :check_authorship, only: %i[destroy update]
  before_action :set_question,     only: %i[create]

  after_action  :publish_answer,   only: %i[create]

  respond_to :js

  def create
    respond_with @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def destroy
    respond_with @answer.destroy
  end

  def update
    respond_with @answer.update(answer_params)
  end

  def best
    return head :forbidden unless current_user.author_of?(@answer.question)
    respond_with @answer.select_as_best
  end

  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "#{@question.id}_question_channel",
      answer: @answer, question: @question,
      answer_rating: @answer.rating,
      author: @answer.user, attachments: @answer.attachments
    )
  end

  def check_authorship
    head :forbidden unless current_user.author_of?(@answer)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: %i[file id _destroy])
  end
end
