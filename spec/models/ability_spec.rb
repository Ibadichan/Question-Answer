# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'For guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'For admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'For user' do
    let(:user)                     { create(:user) }
    let(:other_user)               { create(:user) }
    let(:vote)                     { create(:vote, votable: create(:question, user: other_user), user: user) }
    let(:answer_of_own_question)   { create(:answer, question: create(:question, user: user)) }
    let(:answer_of_other_question) { create(:answer, question: create(:question, user: other_user)) }
    let(:already_best_answer)      { create(:answer, best: true, question: create(:question, user: user)) }
    let(:own_attachment)           { create(:attachment, attachable: create(:question, user: user)) }
    let(:other_attachment)         { create(:attachment, attachable: create(:answer, user: other_user)) }
    let(:question)                 { create(:question) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should be_able_to :update, create(:answer,   user: user), user: user }
    it { should be_able_to :update, create(:comment,  user: user), user: user }

    it { should_not be_able_to :update, create(:question, user: other_user), user: user }
    it { should_not be_able_to :update, create(:answer,   user: other_user), user: user }
    it { should_not be_able_to :update, create(:comment,  user: other_user), user: user }

    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should be_able_to :destroy, create(:answer,   user: user), user: user }
    it { should be_able_to :destroy, create(:comment,  user: user), user: user }

    it { should_not be_able_to :destroy, create(:question, user: other_user), user: user }
    it { should_not be_able_to :destroy, create(:answer,   user: other_user), user: user }
    it { should_not be_able_to :destroy, create(:comment,  user: other_user), user: user }

    it { should be_able_to :re_vote, vote.votable, user: user }
    it { should_not be_able_to :re_vote, create(:question, user: other_user), user: user }

    it { should be_able_to :vote_for,     create(:question, user: other_user), user: user }
    it { should be_able_to :vote_against, create(:question, user: other_user), user: user }

    it { should_not be_able_to :vote_against, create(:question, user: user), user: user }
    it { should_not be_able_to :vote_for,     create(:question, user: user), user: user }

    it { should be_able_to :select_as_best, answer_of_own_question, user: user }
    it { should_not be_able_to :select_as_best, answer_of_other_question, user: user }
    it { should_not be_able_to :select_as_best, already_best_answer, user: user }

    it { should be_able_to :destroy, own_attachment, user: user }
    it { should_not be_able_to :destroy, other_attachment, user: user }

    it { should be_able_to :subscribe, create(:question, user: other_user), user: user }
    it { should_not be_able_to :subscribe, create(:question, user: user), user: user }

    it do
      question.subscriptions.create(user: user)
      should_not be_able_to :subscribe, question, user: user
    end

    it do
      question.subscriptions.create(user: user)
      should be_able_to :unsubscribe, question, user: user
    end

    it { should_not be_able_to :unsubscribe, create(:question, user: other_user), user: user }
    it { should be_able_to :unsubscribe, create(:question, user: user), user: user }
  end
end
