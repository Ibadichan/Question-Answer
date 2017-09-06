# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyMailer, type: :mailer do
  let(:user)      { create(:user) }
  let(:mail)      { DailyMailer.digest(user) }
  let!(:questions) { create_list(:question, 2) }

  describe 'digest' do
    it('renders subject')            { expect(mail.subject).to eq 'Daily Digest' }
    it('sends digest to user email') { expect(mail.to).to eq [user.email] }

    it 'assigns questions of today to @questions' do
      questions.each do |question|
        expect(mail.body.encoded).to match question.title
        expect(mail.body.encoded).to match "/questions/#{question.id}"
      end
    end
  end
end
