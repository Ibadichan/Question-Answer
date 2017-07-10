# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  describe '.by_best' do
    let(:answers) { create_list(:answer, 2) }
    let(:best_answer) { create(:answer, best: true) }

    it 'sorts the answers by best flag' do
      answers << best_answer
      expect(Answer.by_best.first.best).to eq true
    end
  end
end
