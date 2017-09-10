# frozen_string_literal: true

class Question < ApplicationRecord
  include Commentable
  include Votable
  include Attachable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: 'user'

  validates :title, :body, presence: true

  scope :of_today, -> { where('created_at >= ?', 1.days.ago) }

  after_create :subscribe_author

  def subscribe_author
    subscriptions.create!(user_id: user.id)
  end

  def get_subscription_by(user)
    subscriptions.where(user_id: user.id).first if user
  end
end
