# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :ensure_sign_up_complete

  def destroy
    @attachment = Attachment.find(params[:id])
    authorize! :destroy, @attachment
    respond_with @attachment.destroy
  end
end
