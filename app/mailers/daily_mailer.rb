# frozen_string_literal: true

class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.of_today
    mail to: user.email, subject: 'Daily Digest'
  end
end
