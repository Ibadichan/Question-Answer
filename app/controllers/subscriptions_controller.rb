# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  load_resource
  before_action :set_question

  def create
    authorize! :subscribe, @question
    respond_with @subscription = @question.subscriptions.create(user_id: current_user.id)
  end

  def destroy
    authorize! :unsubscribe, @question
    respond_with @subscription.destroy
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
