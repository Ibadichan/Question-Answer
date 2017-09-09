# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsMailer, type: :mailer do
  let(:author)   { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer)   { create(:answer, question: question) }

  describe 'new_answer' do
    let(:mail) { QuestionsMailer.new_answer(answer, question, author) }

    it 'renders the headers' do
      expect(mail.subject).to eq 'Notification'
      expect(mail.to).to eq [author.email]
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match answer.body
      expect(mail.body.encoded).to match question.title
      expect(mail.body.encoded).to match "questions/#{question.id}"
    end
  end
end
