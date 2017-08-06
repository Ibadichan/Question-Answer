# frozen_string_literal: true

class QuestionsChannel < ApplicationCable::Channel
  def follow
    stream_from 'questions'
  end

  def follow_for_question
    stream_from "#{params[:question_id]}_question_channel"
  end
end
