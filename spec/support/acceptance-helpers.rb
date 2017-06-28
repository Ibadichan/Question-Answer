# frozen_string_literal: true

module AcceptanceHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Пароль', with: user.password
    click_on 'Log in'
  end
end