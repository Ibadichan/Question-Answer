# frozen_string_literal: true

shared_examples_for 'API Commentable' do
  context 'comments' do
    it('contains comment') { expect(response.body).to have_json_size(1).at_path("#{parent}/comments") }

    %w[id body commentable_type commentable_id created_at updated_at user_id].each do |attr|
      it "contains #{attr} of comment" do
        expect(response.body).to be_json_eql(
          comment.send(attr.to_sym).to_json
        ).at_path("#{parent}/comments/0/#{attr}")
      end
    end
  end
end
