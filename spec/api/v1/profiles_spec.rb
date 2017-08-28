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
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w[password encrypted_password].each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET #all' do
    context 'Unauthorized' do
      it 'returns 401 status if there is not access token' do
        get '/api/v1/profiles/all', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/profiles/all', params: { access_token: '12345', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'Authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/all', params: { access_token: access_token.token, format: :json } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it { expect(response.body).to have_json_size(3) }

      it 'contains users' do
        expect(response.body).to be_json_eql(users.to_json)
      end

      it 'excepts current user' do
        expect(response.body).to_not have_json_path(me.to_json)
      end
    end
  end
end
