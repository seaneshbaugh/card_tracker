require 'spec_helper'

describe 'registrations' do
  context '#new' do
    it 'should show the registration form' do
      visit new_user_registration_path

      page.should have_selector('#register')

      page.should have_selector('form#new_user')

      page.should have_selector('form#new_user input[type="text"]#user_username')

      page.should have_selector('form#new_user input[type="email"]#user_email')

      page.should have_selector('form#new_user input[type="password"]#user_password')

      page.should have_selector('form#new_user input[type="password"]#user_password_confirmation')

      page.should have_selector('form#new_user input[type="submit"]')

      page.should have_content(I18n.t('navigation.register'))
    end

    it 'should allow new users to register' do
      User.count.should eq(0)

      visit new_user_registration_path

      fill_in 'user_username', :with => 'testuser'

      fill_in 'user_email', :with => 'test@test.com'

      fill_in 'user_password', :with => 'verylongpassword'

      fill_in 'user_password_confirmation', :with => 'verylongpassword'

      click_button 'Register'

      page.should have_content('A message with a confirmation link has been sent to your email address. Please open the link to activate your account.')

      User.count.should eq(1)
    end
  end
end
