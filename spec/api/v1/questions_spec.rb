# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create(:access_token) }

  describe 'GET #index' do
    it_behaves_like 'API Authenticable'

    context 'Authorized' do
      let!(:questions) { create_list(:question, 2) }

      before { get '/api/v1/questions', params: { access_token: access_token.token, format: :json } }

      it('returns status 200 OK') { expect(response).to be_success }
      it('returns list of questions') do
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

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    it_behaves_like 'API Authenticable'

    context 'Authorized' do
      let!(:comment)    { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question) }
      let!(:answer)     { create(:answer, question: question) }
      let(:parent) { question.class.name.underscore }

      before do
        get "/api/v1/questions/#{question.id}",
            params: { access_token: access_token.token, format: :json }
      end

      it('returns status 200')   { expect(response).to be_success }
      it('returns the question') { expect(response.body).to have_json_size(1) }

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
        it('includes answers') do
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

      it_behaves_like 'API Commentable'
      it_behaves_like 'API Attachable'
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    it_behaves_like 'API Authenticable'

    context 'Authorized' do
      before do
        post '/api/v1/questions',
             params: { access_token: access_token.token, question: attributes_for(:question), format: :json }
      end

      it('returns status 200')   { expect(response).to be_success }
      it('returns the question') { expect(response.body).to have_json_size(1) }

      it 'creates a new question' do
        expect do
          post '/api/v1/questions',
               params: { access_token: access_token.token,
                         question: attributes_for(:question), format: :json }
        end.to change(Question, :count).by(1)
      end

      %w[id title body created_at updated_at user_id].each do |attr|
        it "contains #{attr} of question" do
          expect(response.body).to be_json_eql(
            assigns(:question).send(attr.to_sym).to_json
          ).at_path("question/#{attr}")
        end
      end

      it 'contains short title of question' do
        expect(response.body).to be_json_eql(
          assigns(:question).title.truncate(10).to_json
        ).at_path('question/short_title')
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end
end
