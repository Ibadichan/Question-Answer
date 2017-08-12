# frozen_string_literal: true

class QuestionsController < ApplicationController
  include PublicIndexAndShow
  include Voted

  before_action :set_question, only: %i[destroy show update]
  before_action :check_authorship, only: %i[destroy update]
  after_action :publish_question, only: :create

  def index
    respond_with @questions = Question.all
  end

  def new
    respond_with @question = Question.new
  end

  def show
    gon.current_user = current_user if current_user
    respond_with @question
  end

  def create
    respond_with @question = current_user.questions.create(question_params)
  end

  def destroy
    respond_with @question.destroy
  end

  def update
    respond_with @question.update(question_params)
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def check_authorship
    head :forbidden unless current_user.author_of?(@question)
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:body, :title, attachments_attributes: %i[file id _destroy])
  end
end
