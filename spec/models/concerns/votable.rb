# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  describe '#rating' do
    let!(:question) { create(:question) }
    let!(:dislikes) { create_list(:vote, 3, value: -1, votable: question) }
    let!(:likes)    { create_list(:vote, 2, value: 1,  votable: question) }

    it('should creates rating') { expect(question.rating).to eq(-1) }
  end

  describe '#destroy_vote_of' do
    let(:question) { create(:question) }
    let(:user)     { create(:user) }
    let!(:vote) { create(:vote, user: user, votable: question) }

    it 'should destroy vote of requested user' do
      expect do
        question.destroy_vote_of(user)
      end.to change(question.votes, :count).by(-1)
    end
  end
end
