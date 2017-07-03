# frozen_string_literal: true

require 'rails_helper'

describe QuestionsController do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all Questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested Question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'connects the user to the question' do
        expect { post :create, params: { question: attributes_for(:question) } }
          .to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save question in database' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 'renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:question_of_user) { create(:question, user: @user) }

    context 'author tries to delete his question' do
      it 'destroys the @question' do
        expect { delete :destroy, params: { id: question_of_user } }.to change(Question, :count).by(-1)
      end

      it 'redirects to questions' do
        delete :destroy, params: { id: question_of_user }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not-author tries to delete answer' do
      it 'does not delete the @question' do
        question
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'renders show view' do
        delete :destroy, params: { id: question }
        expect(response).to render_template :show
      end
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, params: {id: question} }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let(:question_of_author) {create(:question, user: @user)}

    context 'Author tries to update question' do
      context 'with valid attributes' do
        it 'assigns requested question to @question ' do
          patch :update, params: {id: question_of_author, question: attributes_for(:question)}
          expect(assigns(:question)).to eq question_of_author
        end

        it 'changes question attributes' do
          patch :update, params: {id: question_of_author, question: {title: 'new title', body: 'new body'}}
          question_of_author.reload
          expect(question_of_author.body).to eq 'new body'
          expect(question_of_author.title).to eq 'new title'
        end

        it 'redirects to @question' do
          patch :update, params: {id: question_of_author, question: attributes_for(:question)}
          expect(response).to redirect_to question_path(question_of_author)
        end

      end

      context 'with invalid attributes' do
        before {patch :update, params: {id: question, question: {title: 'new title', body: nil}}}

        it 'does not change question attributes' do
          question.reload
          expect(question.body).not_to eq 'new title'
          expect(question.title).not_to eq nil
        end

        it 'renders edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'Non-author tries to update question' do
      before { patch :update, params: {id: question, question: {title: 'new title', body: 'new body'}}}

      it 'does not change question attributes' do
        question.reload
        expect(question.body).not_to eq 'new body'
        expect(question.title).not_to eq 'new title'
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end
end
