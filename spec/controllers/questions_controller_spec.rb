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

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
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
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let!(:question_of_user) { create(:question, user: @user) }

    context 'Author tries to update question' do
      it 'assigns question to @question' do
        patch :update, params: { id: question_of_user, question: attributes_for(:question),
                                 format: :js }
        expect(assigns(:question)).to eq question_of_user
      end

      it 'changes the attributes of question' do
        patch :update, params: { id: question_of_user,
                                 question: { title: 'new title', body: 'new body' },
                                 format: :js }
        question_of_user.reload
        expect(question_of_user.title).to eq 'new title'
        expect(question_of_user.body).to eq 'new body'
      end

      it 'render update view' do
        patch :update, params: { id: question_of_user,
                                 question: attributes_for(:question),
                                 format: :js }
        expect(response).to render_template :update
      end
    end

    context 'Non author tries to update question' do
      it 'does not changes the attributes' do
        patch :update, params: { id: question,
                                 question: { title: 'new title', body: 'new body' },
                                 format: :js }
        question.reload
        expect(question.body).to_not eq 'new body'
        expect(question.title).to_not eq 'new title'
      end
    end
  end
end
