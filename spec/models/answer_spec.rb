# frozen_string_literal: true

require 'rails_helper'
require_all 'spec/models/concerns'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it_behaves_like 'attachable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should validate_presence_of :body }

  describe '.by_best' do
    let!(:answers)     { create_list(:answer, 2) }
    let!(:best_answer) { create(:answer, best: true) }

    it 'sorts the answers by best flag' do
      expect(Answer.by_best.first).to eq best_answer
      expect(Answer.by_best.first).to be_best
    end
  end

  describe '#select_best' do
    let!(:question)        { create(:question) }
    let!(:old_best_answer) { create(:answer, question: question, best: true) }
    let!(:new_answer)      { create(:answer, question: question) }

    before { new_answer.select_as_best }

    it('changes field best of answer') { expect(new_answer).to be_best }

    it 'set false to all others answers' do
      old_best_answer.reload
      expect(old_best_answer).to_not be_best
    end
  end

  describe '#notify_subscribers' do
    let(:answer) { build(:answer) }
    after { answer.save! }

    it 'calls notify_subscribers after creating' do
      expect(answer).to receive(:notify_subscribers).and_call_original
    end

    it 'calls NotifyUserJob' do
      expect(NotifyUserJob).to receive(:perform_later).with(answer).and_call_original
    end
  end
end
