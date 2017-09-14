# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  let(:query)    { 'Запрос'  }
  let(:category) { 'Вопросы' }

  describe 'GET #show' do
    it 'calls  find method of class Search' do
      expect(Search).to receive(:find_object).with(query, category)
      get :show, params: { query: query, category: category }
    end

    it 'renders show template' do
      get :show
      expect(response).to render_template :show
    end
  end
end
