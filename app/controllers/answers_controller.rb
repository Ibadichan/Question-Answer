# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :set_answer, only: %i[destroy update best]
  before_action :check_authorship, only: %i[destroy update]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def destroy
    @answer.destroy
  end

  def update
    @question = @answer.question
    @answer.update(answer_params)
  end

  def best
    @question = @answer.question
    return head :forbidden unless current_user.author_of?(@question)
    @answer.select_as_best
  end

  private

  def check_authorship
    head :forbidden unless current_user.author_of?(@answer)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: %i[file id _destroy])
  end
end
