# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API' do
  describe 'GET #index' do
    context 'Unauthorized' do
      it 'returns 401 status if there is not access token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/questions', params: { access_token: '12345', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'Authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:access_token) { create(:access_token) }

      before { get '/api/v1/questions', params: { access_token: access_token.token, format: :json } }

      it 'returns status 200 OK' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w[id title body created_at updated_at user_id].each do |attr|
        it "contains #{attr} of question" do
          object = questions.first.send(attr.to_sym).to_json
          expect(response.body).to be_json_eql(object).at_path("0/#{attr}")
        end
      end
    end
  end
end
