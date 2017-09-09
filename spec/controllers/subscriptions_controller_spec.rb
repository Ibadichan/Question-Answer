# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:question) { create(:question) }
  sign_in_user

  describe 'POST #create' do
    it 'assigns given question to @question' do
      post :create, params: { question_id: question, format: :js }
      expect(assigns(:question)).to eq question
    end

    it 'creates a new subscription for question' do
      expect do
        post :create, params: { question_id: question, format: :js }
      end.to change(question.subscriptions, :count).by(1)
    end

    it 'connects subscription with current user' do
      expect do
        post :create, params: { question_id: question, format: :js }
      end.to change(@user.subscriptions, :count).by(1)
    end

    it 'renders create template' do
      post :create, params: { question_id: question, format: :js }
      expect(response).to render_template 'create'
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, user: @user, question: question) }

    it 'assigns given question to @question' do
      delete :destroy, params: { question_id: question, id: subscription, format: :js }
      expect(assigns(:question)).to eq question
    end

    it 'destroys the subscription' do
      expect do
        delete :destroy, params: { question_id: question, id: subscription, format: :js }
      end.to change(question.subscriptions, :count).by(-1)
    end

    it 'destroys the subscription' do
      expect do
        delete :destroy, params: { question_id: question, id: subscription, format: :js }
      end.to change(@user.subscriptions, :count).by(-1)
    end

    it 'renders destroy template' do
      delete :destroy, params: { question_id: question, id: subscription, format: :js }
      expect(response).to render_template 'destroy'
    end
  end
end
