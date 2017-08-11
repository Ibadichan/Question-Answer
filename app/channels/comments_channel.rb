# frozen_string_literal: true

class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "#{params[:question_id]}_comments_channel"
  end
end
