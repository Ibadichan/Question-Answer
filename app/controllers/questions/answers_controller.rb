class Questions::AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy]

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      redirect_to @question, alert: 'Ответ успешно создан'
    else
      redirect_to @question, alert: 'Ваш ответ не создан'
    end
  end

  def destroy
    @question = @answer.question
    @answer.destroy
    redirect_to question_path(@question), alert: 'Ваш ответ удален'
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
