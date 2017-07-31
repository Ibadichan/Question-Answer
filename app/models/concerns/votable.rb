# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.likes_count - votes.dislikes_count
  end

  def destroy_vote_of(user)
    votes.where(user_id: user.id).first.try(:destroy)
  end
end
