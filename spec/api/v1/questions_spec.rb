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
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token, format: :json } }

      it 'returns status 200 OK' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w[id title body created_at updated_at user_id].each do |attr|
        it "contains #{attr} of question" do
          expect(response.body).to be_json_eql(
            question.send(attr.to_sym).to_json
          ).at_path("questions/0/#{attr}")
        end
      end

      it 'contains short title of question' do
        expect(response.body).to be_json_eql(
          question.title.truncate(10).to_json
        ).at_path('questions/0/short_title')
      end

      context 'with answers' do
        it 'includes answers' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w[id body question_id created_at updated_at user_id best].each do |attr|
          it "contains #{attr} of answer" do
            expect(response.body).to be_json_eql(
              answer.send(attr.to_sym).to_json
            ).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end
end
