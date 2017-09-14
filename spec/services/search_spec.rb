# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search do
  let(:query) { 'Запрос' }

  describe '.find_object' do
    %w[Question Answer Comment User].each_with_index do |value, index|
      context "category is #{value}" do
        it "returns found #{value}" do
          expect(value.constantize).to receive(:search).with(query).and_call_original
          Search.find_object(query, Search::CATEGORIES[index])
        end
      end
    end

    context 'all categories' do
      it 'returns objects' do
        expect(ThinkingSphinx).to receive(:search).with(query).and_call_original
        Search.find_object(query, 'Все категории')
      end
    end
  end
end
