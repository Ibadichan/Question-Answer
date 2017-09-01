# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:author)     { create(:user) }
    let(:user)       { create(:user) }
    let(:question)   { create(:question, user: author) }

    context 'user is author' do
      it('returns true') { expect(author).to be_author_of(question) }
    end

    context 'user not is author' do
      it('returns false') { expect(user).to_not be_author_of(question) }
    end
  end

  describe '#cannot_vote_for?' do
    let(:user)       { create(:user) }
    let(:question)   { create(:question) }
    let(:vote)       { create(:vote, user: user, votable: question) }

    context 'user tries to vote first time' do
      it('returns false') { expect(user.cannot_vote_for?(question)).to eq false }
    end

    context 'user tries to vote second time' do
      it 'returns true' do
        vote
        expect(user.cannot_vote_for?(question)).to eq true
      end
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }

    context 'User has authorization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'User has not authorization' do
      context 'User already exists' do
        let(:auth) do
          OmniAuth::AuthHash.new(provider: 'facebook',
                                 uid: '123456', info: { email: user.email })
        end

        it 'does not create a new User' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user with uid and provider' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
          expect(user.authorizations.first.provider).to eq auth.provider
          expect(user.authorizations.first.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'User does not exist' do
        context 'Auth email exists' do
          let(:auth) do
            OmniAuth::AuthHash.new(provider: 'facebook',
                                   uid: '123456', info: { email: 'test@example.com', name: 'Ivan' })
          end

          it 'creates a new user' do
            expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
          end

          it 'fills email and name for user' do
            user = User.find_for_oauth(auth)
            expect(user.email).to eq auth.info.email
            expect(user.name).to eq auth.info.name
          end

          it 'creates a new authorization' do
            expect { User.find_for_oauth(auth) }.to change(Authorization, :count).by(1)
          end

          it 'fills provider and uid for authorization' do
            authorization = User.find_for_oauth(auth).authorizations.first
            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end

          it('returns user') { expect(User.find_for_oauth(auth)).to be_a(User) }
        end

        context 'Auth email does not exist' do
          let(:auth) do
            OmniAuth::AuthHash.new(provider: 'twitter',
                                   uid: '123456', info: { name: 'Ivan' })
          end

          it 'creates a new user' do
            expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
          end

          it 'generates email and fills name for user' do
            user = User.find_for_oauth(auth)
            expect(user.email).to eq "change@me-#{auth.uid}-#{auth.provider}.com"
            expect(user.name).to eq auth.info.name
          end

          it 'creates a new authorization' do
            expect { User.find_for_oauth(auth) }.to change(Authorization, :count).by(1)
          end

          it 'fills provider and uid for authorization' do
            authorization = User.find_for_oauth(auth).authorizations.first
            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end

          it('returns user') { expect(User.find_for_oauth(auth)).to be_a(User) }
        end
      end
    end
  end

  describe '#email_verified?' do
    let(:user) { create(:user) }
    let(:invalid_user) { create(:user, email: 'change@me') }

    context 'Email is not fake' do
      it('returns true') { expect(user.email_verified?).to eq true }
    end

    context 'Email is fake' do
      it('returns false') { expect(invalid_user.email_verified?).to eq false }
    end
  end
end
