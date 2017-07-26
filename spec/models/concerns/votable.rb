# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  describe '#rating' do
    let!(:question) { create(:question) }
    let!(:dislikes) { create_list(:vote, 3, value: -1, votable: question) }
    let!(:likes)    { create_list(:vote, 2, value: 1,  votable: question) }
    it 'should creates rating' do
      expect(question.rating).to eq(-1)
    end
  end
end
