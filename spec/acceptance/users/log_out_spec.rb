require 'rails_helper'

feature 'User log out', %q{
  In order to be able finish the session
  As an authenticated user
  I want to log out
} do

  given(:user) {create(:user)}

  scenario 'User tries to log out' do
    sign_in(user)

    click_on 'Выйти'

    expect(current_path).to eq root_path
  end
end
