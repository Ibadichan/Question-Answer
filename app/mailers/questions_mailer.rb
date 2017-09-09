# frozen_string_literal: true

class QuestionsMailer < ApplicationMailer
  def new_answer(answer, question, user)
    @answer = answer
    @question = question
    mail to: user.email, subject: 'Notification'
  end
end
