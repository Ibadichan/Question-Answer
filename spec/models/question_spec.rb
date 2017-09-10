# frozen_string_literal: true

require 'rails_helper'
require_all 'spec/models/concerns'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it_behaves_like 'attachable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe '.of_today' do
    let!(:new_questions) { create_list(:question, 2) }
    let!(:old_question)  { create(:question, created_at: Time.now - 2.day) }

    it('selects the questions of today') { expect(Question.of_today).to eq new_questions }
    it('does not select old questions') { expect(Question.of_today).to_not include old_question }
  end

  describe '#subscribe_author' do
    let(:author)   { create(:user) }
    let(:question) { build(:question, user: author) }

    it 'creates a new subscription for author' do
      expect { question.save! }.to change(author.subscriptions, :count).by(1)
    end

    it 'calls subscribe_author after creating' do
      expect(question).to receive(:subscribe_author).and_call_original
      question.save!
    end
  end

  describe '#get_subscription_by' do
    let(:user)     { create(:user) }
    let(:question) { create(:question) }

    it 'returns subscription' do
      subscription = user.subscriptions.create(question_id: question.id)
      expect(question.get_subscription_by(user)).to eq subscription
    end
  end
end
