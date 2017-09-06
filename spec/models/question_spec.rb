# frozen_string_literal: true

require 'rails_helper'
require_all 'spec/models/concerns'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }

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
end
