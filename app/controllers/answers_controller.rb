# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy update best]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def destroy
    return unless current_user.author_of?(@answer)
    @answer.destroy
    render :delete
  end

  def update
    @question = @answer.question
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def best
    @question = @answer.question

    return unless current_user.author_of?(@question)
    @question.answers.update_all(best: false)
    @answer.best = true
    @answer.save
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :best)
  end
end
