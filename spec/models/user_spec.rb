# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?(object)' do
    let(:author)     { create(:user) }
    let(:question)   { create(:question, user: author) }
    let(:answer)     { create(:answer, user: author) }
    let(:user)       { create(:user)}

    context 'user is author' do
      it 'returns true if user is author' do
        expect(author.author_of?(question)).to be true
        expect(author.author_of?(answer)).to be true
      end
    end

    context 'user not is author' do
      it 'returns false if user not is author' do
        expect(user.author_of?(question)).to be_falsey
        expect(user.author_of?(answer)).to be_falsey
      end
    end
  end
end
