# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_for vote_against re_vote]
  end

  def vote_for
    authorize! :vote_for, @votable
    @vote = @votable.votes.create(value: 1, user: current_user)
    render json: { votable: @votable, rating: @votable.rating }
  end

  def vote_against
    authorize! :vote_against, @votable
    @vote = @votable.votes.create(value: -1, user: current_user)
    render json: { votable: @votable, rating: @votable.rating }
  end

  def re_vote
    authorize! :re_vote, @votable
    @votable.destroy_vote_of(current_user)
    render json: { votable: @votable, rating: @votable.rating }
  end

  private

  def set_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
end
