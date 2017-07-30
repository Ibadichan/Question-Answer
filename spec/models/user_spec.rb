# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:author)     { create(:user) }
    let(:user)       { create(:user) }
    let(:question)   { create(:question, user: author) }

    context 'user is author' do
      it 'returns true' do
        expect(author).to be_author_of(question)
      end
    end

    context 'user not is author' do
      it 'returns false' do
        expect(user).to_not be_author_of(question)
      end
    end
  end

  describe '#cannot_vote_for?' do
    let(:user)       { create(:user) }
    let(:question)   { create(:question) }
    let(:vote)       { create(:vote, user: user, votable: question) }

    context 'user tries to vote first time' do
      it 'returns false' do
        expect(user.cannot_vote_for?(question)).to eq false
      end
    end

    context 'user tries to vote second time' do
      it 'returns true' do
        vote
        expect(user.cannot_vote_for?(question)).to eq true
      end
    end
  end
end
