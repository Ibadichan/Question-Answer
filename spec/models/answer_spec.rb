# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  describe '.by_best' do
    let!(:answers) { create_list(:answer, 2) }
    let!(:best_answer) { answers << create(:answer, best: true) }

    it 'sorts the answers by best flag' do
      expect(Answer.by_best.first.best).to eq true
    end
  end

  describe '#select_best' do
    let(:answer) { create(:answer) }

    it 'changes field best of answer' do
      answer.select_as_best
      expect(answer.best).to eq true
    end
  end
end
