# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    respond_with Question.all
  end
end
