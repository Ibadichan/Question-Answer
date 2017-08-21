# frozen_string_literal: true

require 'rails_helper'

describe OmniauthCallbacksController, type: :controller do
  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET|POST #facebook' do
    before do
      request.env['omniauth.auth'] = mock_facebook_auth_hash
      get :facebook, params: { omniauth_auth: request.env['omniauth.auth'] }
    end

    it 'assigns the found user to @user' do
      expect(assigns(:user)).to be_a(User)
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end
  end

  describe 'GET|POST #twitter' do
    context 'Email is not verified' do
      before do
        request.env['omniauth.auth'] = mock_twitter_auth_hash
        get :twitter, params: { omniauth_auth: request.env['omniauth.auth'] }
      end

      it 'assigns the found user to @user' do
        expect(assigns(:user)).to be_a(User)
      end

      it 'redirects to finish_sign_up_path' do
        expect(response).to redirect_to finish_sign_up_path(assigns(:user))
      end
    end

    context 'Email is verified' do
      let(:user) { create(:user) }
      let!(:authorization) do
        create(:authorization, provider: mock_twitter_auth_hash.provider,
                               uid: mock_twitter_auth_hash.uid, user: user)
      end

      it 'redirects to root path' do
        request.env['omniauth.auth'] = mock_twitter_auth_hash
        get :twitter, params: { omniauth_auth: request.env['omniauth.auth'] }

        expect(response).to redirect_to root_path
      end
    end
  end
end
