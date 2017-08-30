# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profile API' do
  describe 'GET #me' do
    context 'Unauthorized' do
      it 'returns 401 status if there is not access token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/profiles/me', params: { access_token: '1234', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'Authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token, format: :json } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w[email name id created_at updated_at admin].each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path("user/#{attr}")
        end
      end

      %w[password encrypted_password].each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path("user/#{attr}")
        end
      end
    end
  end

  describe 'GET #index' do
    context 'Unauthorized' do
      it 'returns 401 status if there is not access token' do
        get '/api/v1/profiles', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/profiles', params: { access_token: '12345', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'Authorized' do
      let!(:users) { create_list(:user, 2) }
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token, format: :json } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'includes users' do
        expect(response.body).to have_json_size(2).at_path('users')
      end

      it 'excepts current user' do
        expect(response.body).to_not have_json_path('users/2')
      end

      %w[email name id created_at updated_at admin].each do |attr|
        it "contains #{attr} of user" do
          expect(response.body).to be_json_eql(
            users.first.send(attr.to_sym).to_json
          ).at_path("users/0/#{attr}")
        end
      end

      %w[password encrypted_password].each do |attr|
        it "does not contain #{attr} of user" do
          expect(response.body).to_not have_json_path("users/0/#{attr}")
        end
      end
    end
  end
end
