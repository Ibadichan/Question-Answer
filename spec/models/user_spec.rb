# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?(object)' do
    let(:author)     { create(:user) }
    let(:user)       { create(:user) }
    let(:question)   { create(:question, user: author) }

    context 'user is author' do
      it 'returns true if user is author' do
        expect(author).to be_author_of(question)
      end
    end

    context 'user not is author' do
      it 'returns false if user not is author' do
        expect(user).to_not be_author_of(question)
      end
    end
  end
end
