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
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w[id title body created_at updated_at user_id].each do |attr|
        it "contains #{attr} of question" do
          expect(response.body).to be_json_eql(
            questions.first.send(attr.to_sym).to_json
          ).at_path("questions/0/#{attr}")
        end
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    let(:access_token) { create(:access_token) }
    let!(:comment) { create(:comment, commentable: question) }
    let!(:attachment) { create(:attachment, attachable: question) }
    let!(:answer) { create(:answer, question: question) }

    context 'Unauthorized' do
      it 'returns 401 status if access token was not submitted' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { access_token: '12345', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'Authorized' do
      before do
        get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, format: :json }
      end

      it 'returns status 200' do
        expect(response).to be_success
      end

      it 'returns the question' do
        expect(response.body).to have_json_size(1)
      end

      %w[id title body created_at updated_at user_id].each do |attr|
        it "contains #{attr} of question" do
          expect(response.body).to be_json_eql(
            question.send(attr.to_sym).to_json
          ).at_path("question/#{attr}")
        end
      end

      it 'contains short title of question' do
        expect(response.body).to be_json_eql(
          question.title.truncate(10).to_json
        ).at_path('question/short_title')
      end

      context 'answers' do
        it 'includes answers' do
          expect(response.body).to have_json_size(1).at_path('question/answers')
        end

        %w[id body question_id created_at updated_at user_id best].each do |attr|
          it "contains #{attr} of answer" do
            expect(response.body).to be_json_eql(
              answer.send(attr.to_sym).to_json
            ).at_path("question/answers/0/#{attr}")
          end
        end
      end

      context 'comments' do
        it 'includes comments' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w[id body commentable_type commentable_id created_at updated_at user_id].each do |attr|
          it "contains #{attr} of comment" do
            expect(response.body).to be_json_eql(
              comment.send(attr.to_sym).to_json
            ).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'includes attachments' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        it 'contains url of attachment' do
          expect(response.body).to be_json_eql(
            attachment.file.url.to_json
          ).at_path('question/attachments/0/url')
        end

        %w[id file created_at updated_at attachable_id attachable_type].each do |attr|
          it "does not contain #{attr} of attachment" do
            expect(response.body).to_not have_json_path("question/attachments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST #create' do
    context 'Unauthorized' do
      it 'returns 401 status if access token was not submitted' do
        post '/api/v1/questions', params: { question: attributes_for(:question),
                                            format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        post '/api/v1/questions', params: { question: attributes_for(:question),
                                            access_token: '123', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'Authorized' do
      let(:access_token) { create(:access_token) }

      it 'returns status 200' do
        post '/api/v1/questions', params: { access_token: access_token.token,
                                            question: attributes_for(:question),
                                            format: :json }
        expect(response).to be_success
      end

      it 'creates a new question' do
        expect do
          post '/api/v1/questions', params: { access_token: access_token.token,
                                              question: attributes_for(:question),
                                              format: :json }
        end.to change(Question, :count).by(1)
      end

      it 'returns the question' do
        post '/api/v1/questions', params: { access_token: access_token.token,
                                            question: attributes_for(:question),
                                            format: :json }
        expect(response.body).to have_json_size(1)
      end

      %w[id title body created_at updated_at user_id].each do |attr|
        it "contains #{attr} of question" do
          post '/api/v1/questions', params: { access_token: access_token.token,
                                              question: attributes_for(:question),
                                              format: :json }

          expect(response.body).to be_json_eql(
            assigns(:question).send(attr.to_sym).to_json
          ).at_path("question/#{attr}")
        end
      end

      it 'contains short title of question' do
        post '/api/v1/questions', params: { access_token: access_token.token,
                                            question: attributes_for(:question),
                                            format: :json }

        expect(response.body).to be_json_eql(
          assigns(:question).title.truncate(10).to_json
        ).at_path('question/short_title')
      end
    end
  end
end
