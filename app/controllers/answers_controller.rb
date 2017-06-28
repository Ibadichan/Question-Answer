# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy]

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      redirect_to @question, notice: 'Ответ успешно создан'
    else
      @question.reload
      # reload , так кака когда я делаю render 'questions/show' у меня у вопроса создается пустой ответ, а мне это
      # не надо, если есть другое решение подскажите пожалуйста.
      flash[:alert] = 'Ваш ответ не создан'
      render 'questions/show'
    end
  end

  def destroy
    @question = @answer.question

    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @question, notice: 'Ваш ответ удален'
    else
      render 'questions/show'
    end
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