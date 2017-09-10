# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question)         { create(:question) }
  let(:question_of_user) { create(:question, user: @user) }

  let(:votable)          { question }
  let(:votable_of_user)  { question_of_user }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all Questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it('renders index view') { expect(response).to render_template 'index' }
  end

  describe 'GET #show' do
    before { get :show, params: { id: question.id } }

    it('assigns the requested Question to @question') do
      expect(assigns(:question)).to eq question
    end

    it('renders show view') { expect(response).to render_template 'show' }
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it('assigns a new Question to @question') do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it('renders new view') { expect(response).to render_template 'new' }
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'connects the user to the question' do
        expect do
          post :create, params: { question: attributes_for(:question) }
        end.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save question in database' do
        expect do
          post :create, params: { question: attributes_for(:invalid_question) }
        end.to_not change(Question, :count)
      end

      it 'renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template 'new'
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    context 'author tries to delete his question' do
      it 'destroys the @question' do
        question_of_user
        expect do
          delete :destroy, params: { id: question_of_user.id }
        end.to change(Question, :count).by(-1)
      end

      it 'redirects to questions' do
        delete :destroy, params: { id: question_of_user.id }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not-author tries to delete answer' do
      it 'does not delete the @question' do
        question
        expect do
          delete :destroy, params: { id: question.id }
        end.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'Author tries to update question' do
      before do |example|
        unless example.metadata[:skip_before]
          patch :update, params: { id: question_of_user.id,
                                   question: attributes_for(:question), format: :js }
        end
      end

      it('assigns question to @question') { expect(assigns(:question)).to eq question_of_user }

      it 'changes the attributes of question', :skip_before do
        patch :update, params: { id: question_of_user.id,
                                 question: { title: 'new title', body: 'new body' }, format: :js }
        question_of_user.reload
        expect(question_of_user.title).to eq 'new title'
        expect(question_of_user.body).to eq 'new body'
      end

      it('render update view') { expect(response).to render_template :update }
    end

    context 'Non author tries to update question' do
      it 'does not changes the attributes', :skip_before do
        patch :update, params: { id: question.id,
                                 question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload
        expect(question.body).to_not eq 'new body'
        expect(question.title).to_not eq 'new title'
      end
    end
  end

  it_behaves_like 'Voted'
end
