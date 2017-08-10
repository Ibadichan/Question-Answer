# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def follow_for_answer
    stream_from "#{params[:answer_id]}_answer_channel"
  end
end
