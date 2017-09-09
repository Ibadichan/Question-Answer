# frozen_string_literal: true

class NotifyUserJob < ApplicationJob
  queue_as :default

  def perform(answer)
    question = answer.question
    question.subscribers.each { |user| QuestionsMailer.new_answer(answer, question, user).deliver_later }
  end
end
