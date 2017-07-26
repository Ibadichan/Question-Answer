# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote do
  it { should belong_to :user }
  it { should belong_to :votable }

  describe '.dislikes_count' do
    let!(:question) { create(:question) }
    let!(:votes)    { create_list(:vote, 2, value: -1, votable: question) }

    it 'returns count of dislikes' do
      expect(question.votes.dislikes_count).to eq 2
    end
  end

  describe '.likes_count' do
    let!(:answer) { create(:answer) }
    let!(:votes)  { create_list(:vote, 2, value: 1, votable: answer) }

    it 'returns count of likes' do
      expect(answer.votes.likes_count).to eq 2
    end
  end
end
