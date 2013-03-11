require 'spec_helper'

describe 'admin' do
  context '#index' do
    it 'should display the Admin Panel home' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      visit admin_root_path

      page.body.should have_selector('#admin-index')

      page.body.should have_content(I18n.t('navigation.admin_home'))
    end

    it 'should display the applications Rails info' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      visit admin_root_path

      page.should have_selector('#rails-info')

      page.should have_content(Rails::VERSION::STRING)
    end

    it 'should display a list of the applications routes' do
      @user = create(:sysadmin_user)

      sign_in(@user)

      visit admin_root_path

      page.should have_selector("#routes")
    end
  end
end
