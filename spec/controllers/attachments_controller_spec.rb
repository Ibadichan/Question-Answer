# frozen_string_literal: true

require 'rails_helper'

describe AttachmentsController do
  describe 'DELETE #destroy' do
    sign_in_user
    let(:question)   { create(:question, user: @user) }
    let(:attachment) { create(:attachment, attachable: question) }

    context 'Author of attachable tries to delete file' do
      before do |example|
        delete :destroy, params: { id: attachment.id, format: :js } unless example.metadata[:skip_before]
      end

      it('assigns attachment to @attachment') { expect(assigns(:attachment)).to eq attachment }

      it 'destroys attachment', :skip_before do
        attachment
        expect do
          delete :destroy, params: { id: attachment.id, format: :js }
        end.to change(Attachment, :count).by(-1)
      end

      it('renders destroy view') { expect(response).to render_template 'destroy' }
    end

    context 'Non-author tries to delete file' do
      it 'does not destroy attachment' do
        expect do
          delete :destroy, params: { id: attachment.id, format: :js }
        end.to_not change(Attachment, :count)
      end
    end
  end
end
