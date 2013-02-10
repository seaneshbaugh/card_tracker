require 'spec_helper'

describe 'sessions' do
  context '#new' do
    it 'should show the login form' do
      visit new_user_session_path

      page.should have_selector('#login')

      page.should have_selector('form#new_user')

      page.should have_selector('form#new_user input[type="text"]#user_username')

      page.should have_selector('form#new_user input[type="password"]#user_password')
    end
  end

  context '#create' do
    it 'should ' do
      password = 'verylongpassword'

      user = create(:user, :password => password, :password_confirmation => password)

      visit new_user_session_path

      fill_in 'user_username', :with => user.username

      fill_in 'user_password', :with => password

      click_button 'Sign In'

      page.should have_content('Signed in successfully.')
    end
  end
end
