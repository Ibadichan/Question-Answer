# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create,  [Question, Answer, Comment]
    can :update,  [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id

    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end

    can :re_vote,        [Question, Answer] { |votable| user.cannot_vote_for?(votable) }
    can :vote_for,       [Question, Answer] { |votable| user_can_vote_for?(votable) }
    can :vote_against,   [Question, Answer] { |votable| user_can_vote_for?(votable) }

    can :select_as_best, Answer do |answer|
      user.author_of?(answer.question) && !answer.best?
    end

    can :subscribe, Question do |question|
      Subscription.where(user_id: user.id, question_id: question.id).size.zero?
    end
  end

  def admin_abilities
    can :manage, :all
  end

  private

  def user_can_vote_for?(votable)
    !user.cannot_vote_for?(votable) && !user.author_of?(votable)
  end
end
