# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted
  load_and_authorize_resource except: :best
  after_action :publish_answer, only: :create

  def create
    @question = Question.find(params[:question_id])
    respond_with @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def destroy
    respond_with @answer.destroy
  end

  def update
    respond_with @answer.update(answer_params)
  end

  def best
    @answer = Answer.find(params[:id])
    authorize! :select_as_best, @answer
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

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: %i[file id _destroy])
  end
end
