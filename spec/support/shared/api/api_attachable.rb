# frozen_string_literal: true

shared_examples_for 'API Attachable' do
  context 'attachments' do
    it('contains attachment') { expect(response.body).to have_json_size(1).at_path("#{parent}/attachments") }

    it 'contains url of attachment' do
      expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("#{parent}/attachments/0/url")
    end

    %w[id file created_at updated_at attachable_id attachable_type].each do |attr|
      it "does not contain #{attr} of attachment" do
        expect(response.body).to_not have_json_path("#{parent}/attachments/0/#{attr}")
      end
    end
  end
end
