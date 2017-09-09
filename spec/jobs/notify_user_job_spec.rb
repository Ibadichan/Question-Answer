# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifyUserJob, type: :job do
  let(:question)      { create(:question) }
  let(:answer)        { create(:answer, question: question) }
  let(:subscriptions) { create_list(:subscription, 2, question: question) }

  it 'calls QuestionsMailer for subscribers' do
    subscriptions.each do |subscription|
      expect(QuestionsMailer).to receive(:new_answer).with(
        answer, question, subscription.user
      ).and_call_original
    end

    expect(QuestionsMailer).to receive(:new_answer).with(answer, question, question.user).and_call_original

    NotifyUserJob.perform_now(answer)
  end
end
