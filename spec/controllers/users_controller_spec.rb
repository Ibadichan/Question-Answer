# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  sign_in_user

  describe 'GET #finish_sign_up' do
    it 'renders template finish_sign_up' do
      get :finish_sign_up, params: { id: @user.id }
      expect(response).to render_template 'finish_sign_up'
    end
  end

  describe 'PATCH #finish_sign_up' do
    it 'updates user email' do
      patch :finish_sign_up, params: { id: @user.id, user: { email: 'test@example.com' } }

      @user.reload
      expect(@user.unconfirmed_email).to eq 'test@example.com'
    end
  end
end
