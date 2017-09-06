# frozen_string_literal: true

class Question < ApplicationRecord
  include Commentable
  include Votable
  include Attachable

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  scope :of_today, -> { where('created_at >= ?', 1.days.ago) }
end
