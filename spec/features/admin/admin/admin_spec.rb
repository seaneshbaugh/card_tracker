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
  end
end
