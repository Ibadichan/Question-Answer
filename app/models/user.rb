# frozen_string_literal: true

class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(object)
    id == object.user_id
  end

  def cannot_vote_for?(votable)
    votable.votes.where(user_id: id).size >= 1
  end
end
