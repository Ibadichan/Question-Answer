require 'application_responder'

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :js, :json

  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :ensure_sign_up_complete, unless: :devise_controller?
  check_authorization unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :forbidden }
      format.js   { render json: exception.message, status: :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end

  def ensure_sign_up_complete
    return if action_name == 'finish_sign_up'
    redirect_to finish_sign_up_path(current_user) if current_user && !current_user.email_verified?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
