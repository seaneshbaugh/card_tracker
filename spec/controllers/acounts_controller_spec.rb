require 'spec_helper'

describe AccountsController do
  include Devise::TestHelpers
  include ControllerSupport

  context '#edit' do
    it 'should not be visible if not signed in' do
      get :edit

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)
    end

    it 'should be visible to read_only users' do
      user = create(:read_only_user)

      sign_in(user)

      get :edit

      response.status.should eq(200)

      response.should render_template('edit')
    end

    it 'should be visible to admin users' do
      user = create(:admin_user)

      sign_in(user)

      get :edit

      response.status.should eq(200)

      response.should render_template('edit')
    end

    it 'should be visible to sysadmin users' do
      user = create(:sysadmin_user)

      sign_in(user)

      get :edit

      response.status.should eq(200)

      response.should render_template('edit')
    end
  end

  context '#update' do
    it 'should let users update their first name' do
      user = create(:read_only_user)

      sign_in(user)

      params = create_params(user)

      params[:first_name] = 'New First Name'

      put :update, :account => params

      response.status.should eq(302)

      response.should redirect_to(edit_account_url)

      updated_user = User.where(:id => user.id).first

      updated_user.first_name.should_not eq(user.first_name)

      updated_user.first_name.should eq('New First Name')
    end

    it 'should let users update their last name' do
      user = create(:read_only_user)

      sign_in(user)

      params = create_params(user)

      params[:last_name] = 'New Last Name'

      put :update, :account => params

      response.status.should eq(302)

      response.should redirect_to(edit_account_url)

      updated_user = User.where(:id => user.id).first

      updated_user.last_name.should_not eq(user.last_name)

      updated_user.last_name.should eq('New Last Name')
    end

    it 'should let users update their email' do
      user = create(:read_only_user)

      sign_in(user)

      params = create_params(user)

      params[:email] = 'newemail@test.com'

      put :update, :account => params

      response.status.should eq(302)

      response.should redirect_to(edit_account_url)

      updated_user = User.where(:id => user.id).first

      updated_user.email.should_not eq(user.email)

      updated_user.email.should eq('newemail@test.com')
    end

    it 'should let users update their username' do
      user = create(:read_only_user)

      sign_in(user)

      params = create_params(user)

      params[:username] = 'newusername'

      put :update, :account => params

      response.status.should eq(302)

      response.should redirect_to(edit_account_url)

      updated_user = User.where(:id => user.id).first

      updated_user.username.should_not eq(user.username)

      updated_user.username.should eq('newusername')
    end
  end

  context '#confirm_delete' do

  end

  context '#destroy' do

  end
end
