# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  load_and_authorize_resource

  def show
    respond_with @answer
  end

  def create
    @question = Question.find(params[:question_id])
    respond_with @answer = @question.answers.create(answer_params.merge(user_id: current_resource_owner.id))
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
