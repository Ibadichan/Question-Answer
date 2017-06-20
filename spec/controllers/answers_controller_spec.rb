# frozen_string_literal: true

require 'rails_helper'

describe AnswersController do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns the Answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the answer in the database' do
        expect do
          post :create, params: { answer: attributes_for(:answer),
                                  question_id: question }
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to answer_path(assigns(:answer))
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer in the database' do
        expect do
          post :create, params: { answer: attributes_for(:invalid_answer),
                                  question_id: question }
        end.to_not change(Answer, :count)
      end

      it 'render new view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to render_template :new
      end
    end
  end
end
