# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.likes_count - votes.dislikes_count
  end
end
