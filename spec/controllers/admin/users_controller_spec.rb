require 'spec_helper'

describe Admin::UsersController do
  include Devise::TestHelpers
  include ControllerSupport

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

  context '#show' do
    it 'should not be visible if not signed in' do
      users = create(:user)

      get :show, :id => users.id

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)
    end

    it 'should not be visible to read_only users' do
      user = create(:read_only_user)

      sign_in(user)

      users = create(:user)

      get :show, :id => users.id

      response.status.should eq(302)

      response.should redirect_to(root_url)
    end

    it 'should be visible to admin users' do
      user = create(:admin_user)

      sign_in(user)

      users = create(:user)

      get :show, :id => users.id

      response.status.should eq(200)

      response.should render_template('show')
    end

    it 'should be visible to sysadmin users' do
      user = create(:sysadmin_user)

      sign_in(user)

      users = create(:user)

      get :show, :id => users.id

      response.status.should eq(200)

      response.should render_template('show')
    end

    it 'should redirect to the User index if the requested User does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      get :show, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_users_url)
    end
  end

  context '#new' do
    it 'should not be visible if not signed in' do
      get :new

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)
    end

    it 'should not be visible to read_only users' do
      user = create(:read_only_user)

      sign_in(user)

      get :new

      response.status.should eq(302)

      response.should redirect_to(root_url)
    end

    it 'should be visible to admin users' do
      user = create(:admin_user)

      sign_in(user)

      get :new

      response.status.should eq(200)

      response.should render_template('new')
    end

    it 'should be visible to sysadmin users' do
      user = create(:sysadmin_user)

      sign_in(user)

      get :new

      response.status.should eq(200)

      response.should render_template('new')
    end
  end

  context '#create' do
    it 'should not create a new User if not signed in' do
      user = build(:user)

      User.count.should eq(0)

      post :create, :user => create_params(user)

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)

      User.count.should eq(0)
    end

    it 'should not allow read_only users to create a new User' do
      user = create(:read_only_user)

      sign_in(user)

      user = build(:user)

      User.count.should eq(1)

      post :create, :user => create_params(user)

      response.status.should eq(302)

      response.should redirect_to(root_url)

      User.count.should eq(1)
    end

    it 'should allow admin users to create a new User' do
      user = create(:admin_user)

      sign_in(user)

      user = build(:user)

      User.count.should eq(1)

      post :create, :user => create_params(user)

      response.status.should eq(302)

      response.should redirect_to(admin_users_url)

      User.count.should eq(2)
    end

    it 'should allow sysadmin users to create a new User' do
      user = create(:sysadmin_user)

      sign_in(user)

      user = build(:user)

      User.count.should eq(1)

      post :create, :user => create_params(user)

      response.status.should eq(302)

      response.should redirect_to(admin_users_url)

      User.count.should eq(2)
    end

    it 'should re-render the new action if the User is invalid' do
      user = create(:sysadmin_user)

      sign_in(user)

      user = build(:user, :username => '')

      User.count.should eq(1)

      post :create, :user => create_params(user)

      response.status.should eq(200)

      response.should render_template('new')

      User.count.should eq(1)
    end

    it 'should not allow admin users to create sysadmin users' do
      user = create(:admin_user)

      sign_in(user)

      user = build(:user, :role => Ability::ROLES[:sysadmin])

      User.count.should eq(1)

      post :create, :user => create_params(user)

      response.status.should eq(302)

      response.should redirect_to(admin_users_url)

      User.count.should eq(2)

      new_user = User.last

      new_user.role.should eq(Ability::ROLES[:read_only])
    end
  end

  context '#edit' do
    it 'should not be visible if not signed in' do
      user = create(:user)

      get :edit, :id => user.id

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)
    end

    it 'should not be visible to read_only users' do
      user = create(:read_only_user)

      sign_in(user)

      user = create(:user)

      get :edit, :id => user.id

      response.status.should eq(302)

      response.should redirect_to(root_url)
    end

    it 'should be visible to admin users' do
      user = create(:admin_user)

      sign_in(user)

      user = create(:user)

      get :edit, :id => user.id

      response.status.should eq(200)

      response.should render_template('edit')
    end

    it 'should be visible to sysadmin users' do
      user = create(:sysadmin_user)

      sign_in(user)

      user = create(:user)

      get :edit, :id => user.id

      response.status.should eq(200)

      response.should render_template('edit')
    end

    it 'should redirect to the User index if the requested User does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      get :edit, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_users_url)
    end
  end

  context '#update' do
    it 'should not edit an existing User if not signed in' do
      user = create(:user)

      params = create_params(user)

      params[:first_name] = 'New First Name'

      put :update, :id => user.id, :user => params

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)

      updated_user = User.where(:id => user.id).first

      updated_user.first_name.should eq(user.first_name)

      updated_user.first_name.should_not eq('New First Name')
    end

    it 'should not allow read_only users to edit an existing User' do
      user = create(:read_only_user)

      sign_in(user)

      user = create(:user)

      params = create_params(user)

      params[:first_name] = 'New First Name'

      put :update, :id => user.id, :user => params

      response.status.should eq(302)

      response.should redirect_to(root_url)

      updated_user = User.where(:id => user.id).first

      updated_user.first_name.should eq(user.first_name)

      updated_user.first_name.should_not eq('New First Name')
    end

    it 'should allow admin users to edit an existing User' do
      user = create(:admin_user)

      sign_in(user)

      user = create(:user)

      params = create_params(user)

      params[:first_name] = 'New First Name'

      put :update, :id => user.id, :user => params

      response.status.should eq(302)

      response.should redirect_to(edit_admin_user_url(:id => user.id))

      updated_user = User.where(:id => user.id).first

      updated_user.first_name.should_not eq(user.first_name)

      updated_user.first_name.should eq('New First Name')
    end

    it 'should allow sysadmin users to edit an existing User' do
      user = create(:sysadmin_user)

      sign_in(user)

      user = create(:user)

      params = create_params(user)

      params[:first_name] = 'New First Name'

      put :update, :id => user.id, :user => params

      response.status.should eq(302)

      response.should redirect_to(edit_admin_user_url(:id => user.id))

      updated_user = User.where(:id => user.id).first

      updated_user.first_name.should_not eq(user.first_name)

      updated_user.first_name.should eq('New First Name')
    end

    it 'should redirect to the User index if the requested User does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      put :update, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_users_url)
    end

    it 'should re-render the edit action if the User is invalid' do
      user = create(:sysadmin_user)

      sign_in(user)

      user = create(:user)

      params = create_params(user)

      params[:username] = ''

      put :update, :id => user.id, :user => params

      response.status.should eq(200)

      response.should render_template('edit')

      updated_user = User.where(:id => user.id).first

      updated_user.username.should eq(user.username)

      updated_user.username.should_not eq('')
    end

    it 'should not allow admin users to edit a users role to be sysadmin' do
      user = create(:admin_user)

      sign_in(user)

      user = create(:read_only_user)

      params = create_params(user)

      params[:role] = Ability::ROLES[:sysadmin]

      put :update, :id => user.id, :user => params

      response.status.should eq(302)

      response.should redirect_to(edit_admin_user_url(user))

      updated_user = User.where(:id => user.id).first

      updated_user.role.should eq(Ability::ROLES[:read_only])

      updated_user.role.should_not eq(Ability::ROLES[:sysadmin])
    end
  end

  context '#destroy' do
    it 'should not delete an existing User if not signed in' do
      user = create(:user)

      User.count.should eq(1)

      delete :destroy, :id => user.id

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)

      User.count.should eq(1)
    end

    it 'should not allow read_only users to delete an existing User' do
      user = create(:read_only_user)

      sign_in(user)

      user = create(:user)

      User.count.should eq(2)

      delete :destroy, :id => user.id

      response.status.should eq(302)

      response.should redirect_to(root_url)

      User.count.should eq(2)
    end

    it 'should allow admin users to delete an existing User' do
      user = create(:admin_user)

      sign_in(user)

      user = create(:user)

      User.count.should eq(2)

      delete :destroy, :id => user.id

      response.status.should eq(302)

      response.should redirect_to(admin_users_url)

      User.count.should eq(1)
    end

    it 'should allow sysadmin users to delete an existing User' do
      user = create(:sysadmin_user)

      sign_in(user)

      user = create(:user)

      User.count.should eq(2)

      delete :destroy, :id => user.id

      response.status.should eq(302)

      response.should redirect_to(admin_users_url)

      User.count.should eq(1)
    end

    it 'should redirect to the User index if the requested User does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      delete :destroy, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_users_url)
    end
  end
end
