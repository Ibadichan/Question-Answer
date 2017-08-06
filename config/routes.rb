# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :vote_for
      post :vote_against
      delete :re_vote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable do
      patch :best, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
