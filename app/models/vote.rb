# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  scope :dislikes_count, (-> { where(value: -1).size })
  scope :likes_count, (-> { where(value: 1).size })
end
