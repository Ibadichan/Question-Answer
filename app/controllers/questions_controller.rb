# frozen_string_literal: true

class QuestionsController < ApplicationController
  include PublicIndexAndShow
  include Voted

  before_action :set_question, only: %i[destroy show update]
  before_action :check_authorship, only: %i[destroy update]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
    @answer = Answer.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Вопрос успешно создан'
    else
      render :new
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Вопрос удален'
  end

  def update
    @question.update(question_params)
  end

  private

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
