# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_for vote_against]
    before_action :check_voter, only: %i[vote_for vote_against]
  end

  def vote_for
    @vote = @votable.votes.create(value: 1, user: current_user)
    render json: @votable.rating
  end

  def vote_against
    @vote = @votable.votes.create(value: -1, user: current_user)
    render json: @votable.rating
  end

  private

  def check_voter
    head :forbidden if current_user.cannot_vote_for?(@votable)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
