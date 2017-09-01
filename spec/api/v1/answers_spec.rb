# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API' do
  let(:question)     { create(:question) }
  let(:answer)       { create(:answer, question: question) }
  let(:access_token) { create(:access_token) }

  describe 'GET #show' do
    it_behaves_like 'API Authenticable'

    context 'Authorized' do
      let(:parent) { answer.class.name.underscore }
      let!(:comment)    { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      before do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}",
            params: { access_token: access_token.token, format: :json }
      end

      it('returns 200 status')     { expect(response.status).to eq 200 }
      it('contains Answer object') { expect(response.body).to have_json_size(1) }

      %w[id body question_id created_at updated_at user_id best].each do |attr|
        it "contains #{attr} of answer" do
          expect(response.body).to be_json_eql(
            answer.send(attr.to_sym).to_json
          ).at_path("answer/#{attr}")
        end
      end

      it_behaves_like 'API Commentable'
      it_behaves_like 'API Attachable'
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}",
          params: { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    it_behaves_like 'API Authenticable'

    context 'Authorized' do
      before do
        post "/api/v1/questions/#{question.id}/answers",
             params: { answer: attributes_for(:answer), access_token: access_token.token, format: :json }
      end

      it('returns 200 status') { expect(response).to be_success }
      it('returns answer object') { expect(response.body).to have_json_size(1) }

      it 'creates a new answer' do
        expect do
          post "/api/v1/questions/#{question.id}/answers",
               params: { answer: attributes_for(:answer), access_token: access_token.token, format: :json }
        end.to change(question.answers, :count).by(1)
      end

      %w[id body question_id created_at updated_at user_id best].each do |attr|
        it "contains #{attr} of answer" do
          expect(response.body).to be_json_eql(
            assigns(:answer).send(attr.to_sym).to_json
          ).at_path("answer/#{attr}")
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end
end
