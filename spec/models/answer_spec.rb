# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it {should have_many :attachments}

  it { should validate_presence_of :body }

  it {should accept_nested_attributes_for :attachments}

  describe '.by_best' do
    let!(:answers) { create_list(:answer, 2) }
    let!(:best_answer) { create(:answer, best: true) }

    it 'sorts the answers by best flag' do
      expect(Answer.by_best.first).to eq best_answer
      expect(Answer.by_best.first).to be_best
    end
  end

  describe '#select_best' do
    let!(:question) { create(:question) }
    let!(:old_best_answer) { create(:answer, question: question, best: true) }
    let!(:new_answer) { create(:answer, question: question) }

    it 'changes field best of answer' do
      new_answer.select_as_best
      expect(new_answer).to be_best
    end

    it 'set false to all others answers' do
      new_answer.select_as_best
      old_best_answer.reload
      expect(old_best_answer).to_not be_best
    end
  end
end
