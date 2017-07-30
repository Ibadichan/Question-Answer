# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question)         { create(:question) }
  let(:question_of_user) { create(:question, user: @user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all Questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template 'index'
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
      expect(response).to render_template 'show'
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template 'new'
    end
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
          delete :destroy, params: { id: question_of_user }
        end.to change(Question, :count).by(-1)
      end

      it 'redirects to questions' do
        delete :destroy, params: { id: question_of_user }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not-author tries to delete answer' do
      it 'does not delete the @question' do
        question
        expect do
          delete :destroy, params: { id: question }
        end.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'Author tries to update question' do
      it 'assigns question to @question' do
        patch :update, params: { id: question_of_user,
                                 question: attributes_for(:question),
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

  describe 'POST #vote_for' do
    sign_in_user
    context 'Non-author tries to vote' do
      it 'assigns the requested votable to @votable' do
        post :vote_for, params: { id: question, format: :json }
        expect(assigns(:votable)).to eq question
      end

      it 'creates a new vote' do
        expect do
          post :vote_for, params: { id: question, format: :json }
        end.to change(question.votes, :count).by(1)
      end

      it 'checks that value of vote to equal 1' do
        post :vote_for, params: { id: question, format: :json }
        expect(assigns(:vote).value).to eq 1
      end
    end

    context 'Author tries to vote' do
      it 'does not create a new vote' do
        expect do
          post :vote_for, params: { id: question_of_user, format: :json }
        end.to_not change(question_of_user.votes, :count)
      end
    end

    context 'Non-author tries to vote 2 times' do
      it 'does not create a new vote' do
        post :vote_for, params: { id: question, format: :json }
        expect do
          post :vote_for, params: { id: question, format: :json }
        end.to_not change(question.votes, :count)
      end
    end
  end

  describe 'POST #vote_against' do
    sign_in_user
    context 'non-author tries to vote' do
      it 'assigns the requested votable to @votable' do
        post :vote_against, params: { id: question, format: :json }
        expect(assigns(:votable)).to eq question
      end

      it 'creates a new vote' do
        expect do
          post :vote_against, params: { id: question, format: :json }
        end.to change(question.votes, :count).by(1)
      end

      it 'checks that value of vote to equal -1' do
        post :vote_against, params: { id: question, format: :json }
        expect(assigns(:vote).value).to eq(-1)
      end
    end
    context 'author tries to vote' do
      it 'does not create a new vote' do
        expect do
          post :vote_against, params: { id: question_of_user, format: :json }
        end.to_not change(question_of_user.votes, :count)
      end
    end
    context 'Non-author tries to vote 2 times' do
      it 'does not create a new vote' do
        post :vote_for, params: { id: question, format: :json }
        expect do
          post :vote_for, params: { id: question, format: :json }
        end.to_not change(question.votes, :count)
      end
    end
  end

  describe 'DELETE #re_vote' do
    sign_in_user
    let(:vote_of_author) { create(:vote, votable: question, user: @user) }
    let(:vote)           { create(:vote, votable: question) }

    context 'author of vote tries to re-vote' do
      it 'assigns the requested votable to @votable' do
        delete :re_vote, params: { id: question, format: :json }
        expect(assigns(:votable)).to eq question
      end

      it 'destroys the vote of author' do
        vote_of_author
        expect do
          delete :re_vote, params: { id: question, format: :json }
        end.to change(question.votes, :count).by(-1)
      end
    end

    context 'Non-author of vote tries to re-vote' do
      it 'does not destroy the vote' do
        vote
        expect do
          delete :re_vote, params: { id: question, format: :json }
        end.to_not change(question.votes, :count)
      end
    end
  end
end
