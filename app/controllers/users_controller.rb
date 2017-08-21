# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :ensure_sign_up_complete

  def finish_sign_up
    @user = User.find(params[:id])
    @user.update(user_params) if request.patch? && user_params[:email]
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
