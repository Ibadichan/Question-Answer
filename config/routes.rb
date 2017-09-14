# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  concern :votable do
    post :vote_for, :vote_against, on: :member
    delete :re_vote, on: :member
  end

  concern :commentable do
    resources :comments, only: :create
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :subscriptions, only: %i[create destroy]
    resources :answers, concerns: %i[votable commentable], shallow: true do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resource :search, only: :show

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers
      end
    end
  end

  mount ActionCable.server => '/cable'

  match '/users/:id/finish_sign_up', to: 'users#finish_sign_up', via: %i[get patch], as: :finish_sign_up

  root to: 'questions#index'
end
