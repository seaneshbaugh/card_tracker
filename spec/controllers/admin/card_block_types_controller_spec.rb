require 'spec_helper'

describe Admin::CardBlockTypesController do
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
      card_block_types = create(:card_block_type)

      get :show, :id => card_block_types.id

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)
    end

    it 'should not be visible to read_only users' do
      user = create(:read_only_user)

      sign_in(user)

      card_block_types = create(:card_block_type)

      get :show, :id => card_block_types.id

      response.status.should eq(302)

      response.should redirect_to(root_url)
    end

    it 'should be visible to admin users' do
      user = create(:admin_user)

      sign_in(user)

      card_block_types = create(:card_block_type)

      get :show, :id => card_block_types.id

      response.status.should eq(200)

      response.should render_template('show')
    end

    it 'should be visible to sysadmin users' do
      user = create(:sysadmin_user)

      sign_in(user)

      card_block_types = create(:card_block_type)

      get :show, :id => card_block_types.id

      response.status.should eq(200)

      response.should render_template('show')
    end

    it 'should redirect to the CardBlockType index if the requested CardBlockType does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      get :show, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_card_block_types_url)
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
    it 'should not create a new CardBlockType if not signed in' do
      card_block_type = build(:card_block_type)

      CardBlockType.count.should eq(0)

      post :create, :card_block_type => create_params(card_block_type)

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)

      CardBlockType.count.should eq(0)
    end

    it 'should not allow read_only users to create a new CardBlockType' do
      user = create(:read_only_user)

      sign_in(user)

      card_block_type = build(:card_block_type)

      CardBlockType.count.should eq(0)

      post :create, :card_block_type => create_params(card_block_type)

      response.status.should eq(302)

      response.should redirect_to(root_url)

      CardBlockType.count.should eq(0)
    end

    it 'should allow admin users to create a new CardBlockType' do
      user = create(:admin_user)

      sign_in(user)

      card_block_type = build(:card_block_type)

      CardBlockType.count.should eq(0)

      post :create, :card_block_type => create_params(card_block_type)

      response.status.should eq(302)

      response.should redirect_to(admin_card_block_types_url)

      CardBlockType.count.should eq(1)
    end

    it 'should allow sysadmin users to create a new CardBlockType' do
      user = create(:sysadmin_user)

      sign_in(user)

      card_block_type = build(:card_block_type)

      CardBlockType.count.should eq(0)

      post :create, :card_block_type => create_params(card_block_type)

      response.status.should eq(302)

      response.should redirect_to(admin_card_block_types_url)

      CardBlockType.count.should eq(1)
    end

    it 'should re-render the new action if the CardBlockType is invalid' do
      user = create(:sysadmin_user)

      sign_in(user)

      card_block_type = build(:card_block_type, :name => '')

      CardBlockType.count.should eq(0)

      post :create, :card_block_type => create_params(card_block_type)

      response.status.should eq(200)

      response.should render_template('new')

      CardBlockType.count.should eq(0)
    end
  end

  context '#edit' do
    it 'should not be visible if not signed in' do
      card_block_type = create(:card_block_type)

      get :edit, :id => card_block_type.id

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)
    end

    it 'should not be visible to read_only users' do
      user = create(:read_only_user)

      sign_in(user)

      card_block_type = create(:card_block_type)

      get :edit, :id => card_block_type.id

      response.status.should eq(302)

      response.should redirect_to(root_url)
    end

    it 'should be visible to admin users' do
      user = create(:admin_user)

      sign_in(user)

      card_block_type = create(:card_block_type)

      get :edit, :id => card_block_type.id

      response.status.should eq(200)

      response.should render_template('edit')
    end

    it 'should be visible to sysadmin users' do
      user = create(:sysadmin_user)

      sign_in(user)

      card_block_type = create(:card_block_type)

      get :edit, :id => card_block_type.id

      response.status.should eq(200)

      response.should render_template('edit')
    end

    it 'should redirect to the CardBlockType index if the requested CardBlockType does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      get :edit, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_card_block_types_url)
    end
  end

  context '#update' do
    it 'should not edit an existing CardBlockType if not signed in' do
      card_block_type = create(:card_block_type)

      params = create_params(card_block_type)

      params[:name] = 'New CardBlockType Name'

      put :update, :id => card_block_type.id, :card_block_type => params

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)

      updated_card_block_type = CardBlockType.where(:id => card_block_type.id).first

      updated_card_block_type.name.should eq(card_block_type.name)

      updated_card_block_type.name.should_not eq('New CardBlockType Name')
    end

    it 'should not allow read_only users to edit an existing CardBlockType' do
      user = create(:read_only_user)

      sign_in(user)

      card_block_type = create(:card_block_type)

      params = create_params(card_block_type)

      params[:name] = 'New CardBlockType Name'

      put :update, :id => card_block_type.id, :card_block_type => params

      response.status.should eq(302)

      response.should redirect_to(root_url)

      updated_card_block_type = CardBlockType.where(:id => card_block_type.id).first

      updated_card_block_type.name.should eq(card_block_type.name)

      updated_card_block_type.name.should_not eq('New CardBlockType Name')
    end

    it 'should allow admin users to edit an existing CardBlockType' do
      user = create(:admin_user)

      sign_in(user)

      card_block_type = create(:card_block_type)

      params = create_params(card_block_type)

      params[:name] = 'New CardBlockType Name'

      put :update, :id => card_block_type.id, :card_block_type => params

      response.status.should eq(302)

      response.should redirect_to(edit_admin_card_block_type_url(:id => card_block_type.id))

      updated_card_block_type = CardBlockType.where(:id => card_block_type.id).first

      updated_card_block_type.name.should_not eq(card_block_type.name)

      updated_card_block_type.name.should eq('New CardBlockType Name')
    end

    it 'should allow sysadmin users to edit an existing CardBlockType' do
      user = create(:sysadmin_user)

      sign_in(user)

      card_block_type = create(:card_block_type)

      params = create_params(card_block_type)

      params[:name] = 'New CardBlockType Name'

      put :update, :id => card_block_type.id, :card_block_type => params

      response.status.should eq(302)

      response.should redirect_to(edit_admin_card_block_type_url(:id => card_block_type.id))

      updated_card_block_type = CardBlockType.where(:id => card_block_type.id).first

      updated_card_block_type.name.should_not eq(card_block_type.name)

      updated_card_block_type.name.should eq('New CardBlockType Name')
    end

    it 'should redirect to the CardBlockType index if the requested CardBlockType does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      put :update, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_card_block_types_url)
    end

    it 'should re-render the edit action if the CardBlockType is invalid' do
      user = create(:sysadmin_user)

      sign_in(user)

      card_block_type = create(:card_block_type)

      params = create_params(card_block_type)

      params[:name] = ''

      put :update, :id => card_block_type.id, :card_block_type => params

      response.status.should eq(200)

      response.should render_template('edit')

      updated_card_block_type = CardBlockType.where(:id => card_block_type.id).first

      updated_card_block_type.name.should eq(card_block_type.name)

      updated_card_block_type.name.should_not eq('')
    end
  end

  context '#destroy' do
    it 'should not delete an existing CardBlockType if not signed in' do
      card_block_type = create(:card_block_type)

      CardBlockType.count.should eq(1)

      delete :destroy, :id => card_block_type.id

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)

      CardBlockType.count.should eq(1)
    end

    it 'should not allow read_only users to delete an existing CardBlockType' do
      user = create(:read_only_user)

      sign_in(user)

      card_block_type = create(:card_block_type)

      CardBlockType.count.should eq(1)

      delete :destroy, :id => card_block_type.id

      response.status.should eq(302)

      response.should redirect_to(root_url)

      CardBlockType.count.should eq(1)
    end

    it 'should allow admin users to delete an existing CardBlockType' do
      user = create(:admin_user)

      sign_in(user)

      card_block_type = create(:card_block_type)

      CardBlockType.count.should eq(1)

      delete :destroy, :id => card_block_type.id

      response.status.should eq(302)

      response.should redirect_to(admin_card_block_types_url)

      CardBlockType.count.should eq(0)
    end

    it 'should allow sysadmin users to delete an existing CardBlockType' do
      user = create(:sysadmin_user)

      sign_in(user)

      card_block_type = create(:card_block_type)

      CardBlockType.count.should eq(1)

      delete :destroy, :id => card_block_type.id

      response.status.should eq(302)

      response.should redirect_to(admin_card_block_types_url)

      CardBlockType.count.should eq(0)
    end

    it 'should redirect to the CardBlockType index if the requested CardBlockType does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      delete :destroy, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_card_block_types_url)
    end
  end
end
