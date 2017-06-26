class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[destroy show]

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
      redirect_to @question, alert: 'Вопрос успешно создан'
    else
      render :new
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, alert: 'Вопрос удален'
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:body, :title)
  end
end
