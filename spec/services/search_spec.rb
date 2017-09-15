# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search do
  let(:query) { 'Запрос' }

  describe '.find_object' do
    %w[questions answers comments users].each do |value|
      context "category is #{value}" do
        it "returns found #{value}" do
          expect(value.classify.constantize).to receive(:search).with(query).and_call_original
          Search.find_object(query, value)
        end
      end
    end

    context 'all categories' do
      it 'returns objects' do
        expect(ThinkingSphinx).to receive(:search).with(query).and_call_original
        Search.find_object(query, 'all_categories')
      end
    end
  end
end
