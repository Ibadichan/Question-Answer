# frozen_string_literal: true

require 'rails_helper'

describe AttachmentsController do
  describe 'DELETE #destroy' do
    sign_in_user
    let(:question) { create(:question, user: @user) }
    let(:attachment) { create(:attachment, attachable: question) }

    context 'Author of attachable tries to delete file' do
      it 'assigns attachable of attachment to @attachable' do
        delete :destroy, params: { id: attachment, format: :js }
        expect(assigns(:attachable)).to eq question
      end

      it 'assigns attachment to @attachment' do
        delete :destroy, params: { id: attachment, format: :js }
        expect(assigns(:attachment)).to eq attachment
      end

      it 'destroys attachment' do
        attachment
        expect do
          delete :destroy, params: { id: attachment, format: :js }
        end.to change(Attachment, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: attachment, format: :js }
        expect(response).to render_template 'destroy'
      end
    end

    context 'Non-author tries to delete file' do
      it 'does not destroy attachment' do
        expect do
          delete :destroy, params: { id: attachment, format: :js }
        end.to_not change(Attachment, :count)
      end
    end
  end
end
