require 'spec_helper'

describe Admin::AdminController do
  include Devise::TestHelpers

  context '#index' do
    it 'should not be visible if not signed in' do
      get :index

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)
    end

    it 'should not be visible to read_only users' do
      user = create(:read_only_user)

      sign_in(user)

      get :index

      response.status.should eq(302)

      response.should redirect_to(root_url)
    end

    it 'should be visible to admin users' do
      user = create(:admin_user)

      sign_in(user)

      get :index

      response.status.should eq(200)

      response.should render_template('index')
    end

    it 'should be visible to sysadmin users' do
      user = create(:sysadmin_user)

      sign_in(user)

      get :index

      response.status.should eq(200)

      response.should render_template('index')
    end
  end
end
