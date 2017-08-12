# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :set_attachment
  before_action :check_authorship

  respond_to :js, only: :destroy

  def destroy
    respond_with @attachment.destroy
  end

  private

  def check_authorship
    head :forbidden unless current_user.author_of?(@attachment.attachable)
  end

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end
end
