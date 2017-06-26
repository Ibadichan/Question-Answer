# frozen_string_literal: true

require 'rails_helper'

describe Questions::AnswersController do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the answer in the database' do
        expect do
          post :create, params: {question_id: question, answer: attributes_for(:answer)}
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to question view' do
        post :create, params: {question_id: question,  answer: attributes_for(:answer)}
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer in the database' do
        expect do
          post :create, params: {answer: attributes_for(:invalid_answer), question_id: question}
        end.to_not change(Answer, :count)
      end

      it 'redirects to question view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before {answer}

    it 'deletes the @answer' do
      expect{delete :destroy, params: {id: answer}}.to change(Answer, :count).by(-1)
    end

    it 'redirects to question of answer' do
      delete :destroy, params: {id: answer}
      expect(response).to redirect_to question_path(assigns(:question))
    end
  end
end
