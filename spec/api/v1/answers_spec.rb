# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API' do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:access_token) { create(:access_token) }

  describe 'GET #show' do
    context 'Unauthorized' do
      it 'returns 401 status if access token was not submitted' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}",
            params: { access_token: '123', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'Authorized' do
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      before do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}",
            params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 status' do
        expect(response.status).to eq 200
      end

      it 'contains Answer object' do
        expect(response.body).to have_json_size(1)
      end

      %w[id body question_id created_at updated_at user_id best].each do |attr|
        it "contains #{attr} of answer" do
          expect(response.body).to be_json_eql(
            answer.send(attr.to_sym).to_json
          ).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'contains comment' do
          expect(response.body).to have_json_size(1).at_path('answer/comments')
        end

        %w[id body commentable_type commentable_id created_at updated_at user_id].each do |attr|
          it "contains #{attr} of comment" do
            expect(response.body).to be_json_eql(
              comment.send(attr.to_sym).to_json
            ).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'contains attachment' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

        it 'contains url of attachment' do
          expect(response.body).to be_json_eql(
            attachment.file.url.to_json
          ).at_path('answer/attachments/0/url')
        end

        %w[id file created_at updated_at attachable_id attachable_type].each do |attr|
          it "does not contain #{attr} of attachment" do
            expect(response.body).to_not have_json_path("answer/attachments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST #create' do
    context 'Unauthorized' do
      it 'returns 401 status if access token was not submitted' do
        post "/api/v1/questions/#{question.id}/answers",
             params: { answer: attributes_for(:answer), format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        post "/api/v1/questions/#{question.id}/answers",
             params: { answer: attributes_for(:answer), access_token: '123', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'Authorized' do
      it 'returns 200 status' do
        post "/api/v1/questions/#{question.id}/answers",
             params: { answer: attributes_for(:answer),
                       access_token: access_token.token, format: :json }
        expect(response).to be_success
      end

      it 'creates a new answer' do
        expect do
          post "/api/v1/questions/#{question.id}/answers",
               params: { answer: attributes_for(:answer),
                         access_token: access_token.token, format: :json }
        end.to change(question.answers, :count).by(1)
      end

      it 'returns answer object' do
        post "/api/v1/questions/#{question.id}/answers",
             params: { answer: attributes_for(:answer),
                       access_token: access_token.token, format: :json }
        expect(response.body).to have_json_size(1)
      end

      %w[id body question_id created_at updated_at user_id best].each do |attr|
        it "contains #{attr} of answer" do
          post "/api/v1/questions/#{question.id}/answers",
               params: { answer: attributes_for(:answer),
                         access_token: access_token.token, format: :json }
          expect(response.body).to be_json_eql(
            assigns(:answer).send(attr.to_sym).to_json
          ).at_path("answer/#{attr}")
        end
      end
    end
  end
end
