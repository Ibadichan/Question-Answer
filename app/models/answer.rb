# frozen_string_literal: true

class Answer < ApplicationRecord
  include Commentable
  include Votable
  include Attachable

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :by_best, (-> { order(best: :desc) })

  after_create :notify_subscribers

  def select_as_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  def notify_subscribers
    NotifyUserJob.perform_later(self)
  end
end
