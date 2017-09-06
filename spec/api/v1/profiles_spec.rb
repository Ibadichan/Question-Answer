# frozen_string_literal: true

require 'rails_helper'

describe 'Profile API' do
  let(:me)           { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET #me' do
    it_behaves_like 'API Authenticable'

    context 'Authorized' do
      before { get '/api/v1/profiles/me', params: { access_token: access_token.token, format: :json } }

      it('returns 200 status') { expect(response).to be_success }

      %w[email name id created_at updated_at admin].each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path("user/#{attr}")
        end
      end

      %w[password encrypted_password].each do |attr|
        it("does not contain #{attr}") { expect(response.body).to_not have_json_path("user/#{attr}") }
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET #index' do
    it_behaves_like 'API Authenticable'

    context 'Authorized' do
      let!(:users) { create_list(:user, 2) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token, format: :json } }

      it('returns 200 status')   { expect(response).to be_success }
      it('includes users')       { expect(response.body).to have_json_size(2).at_path('users') }
      it('excepts current user') { expect(response.body).to_not have_json_path('users/2') }

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

    def do_request(options = {})
      get '/api/v1/profiles', params: { format: :json }.merge(options)
    end
  end
end
