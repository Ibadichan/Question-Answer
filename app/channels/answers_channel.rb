# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "#{params[:question_id]}_answers_channel"
  end
end
