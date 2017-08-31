# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    respond_with Question.all
  end

  def show
    respond_with @question
  end

  def create
    respond_with @question = Question.create(question_params.merge(user: current_resource_owner))
  end

  private

  def question_params
    params.require(:question).permit(:body, :title)
  end
end
