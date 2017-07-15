# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :attachments, dependent: :destroy
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
end
