# frozen_string_literal: true

module ControllerMacros
  def sign_in_user
    before do
      @user = create(:user, confirmed_at: Time.now - 1.days)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end
end
