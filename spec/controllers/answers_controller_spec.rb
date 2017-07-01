# frozen_string_literal: true

require 'rails_helper'

describe AnswersController do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the answer in the database' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        end.to change(question.answers, :count).by(1)
      end

      it 'connects the user to the answer' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        end.to change(@user.answers, :count).by(1)
      end

      it 'render create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template 'create'
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer in the database' do
        expect do
          post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        end.to_not change(Answer, :count)
      end

      it 'render create view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        expect(response).to render_template 'create'
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let(:answer_of_user) { create(:answer, user: @user) }

    context 'Author tries to delete his answer' do
      it 'deletes the @answer' do
        answer_of_user
        expect { delete :destroy, params: { id: answer_of_user } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question of answer' do
        delete :destroy, params: { id: answer_of_user }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'Not-author tries to delete  answer' do
      it 'does not delete the @answer' do
        answer
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'render question of answer view' do
        delete :destroy, params: { id: answer }
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
