# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  concern :votable do
    member do
      post :vote_for
      post :vote_against
      delete :re_vote
    end
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, concerns: %i[votable commentable], shallow: true do
      patch :best, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  namespace :api do
    namespace :v1 do
      resource :profiles do
        collection do
          get :me
          get :all
        end
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'

  match '/users/:id/finish_sign_up', to: 'users#finish_sign_up', via: %i[get patch], as: :finish_sign_up
end
