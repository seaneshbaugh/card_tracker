require 'spec_helper'

describe Admin::CardSetsController do
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
      card_sets = create(:card_set)

      get :show, :id => card_sets.id

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)
    end

    it 'should not be visible to read_only users' do
      user = create(:read_only_user)

      sign_in(user)

      card_sets = create(:card_set)

      get :show, :id => card_sets.id

      response.status.should eq(302)

      response.should redirect_to(root_url)
    end

    it 'should be visible to admin users' do
      user = create(:admin_user)

      sign_in(user)

      card_sets = create(:card_set)

      get :show, :id => card_sets.id

      response.status.should eq(200)

      response.should render_template('show')
    end

    it 'should be visible to sysadmin users' do
      user = create(:sysadmin_user)

      sign_in(user)

      card_sets = create(:card_set)

      get :show, :id => card_sets.id

      response.status.should eq(200)

      response.should render_template('show')
    end

    it 'should redirect to the CardSet index if the requested CardSet does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      get :show, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_card_sets_url)
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
    it 'should not create a new CardSet if not signed in' do
      card_set = build(:card_set)

      CardSet.count.should eq(0)

      post :create, :card_set => create_params(card_set)

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)

      CardSet.count.should eq(0)
    end

    it 'should not allow read_only users to create a new CardSet' do
      user = create(:read_only_user)

      sign_in(user)

      card_set = build(:card_set)

      CardSet.count.should eq(0)

      post :create, :card_set => create_params(card_set)

      response.status.should eq(302)

      response.should redirect_to(root_url)

      CardSet.count.should eq(0)
    end

    it 'should allow admin users to create a new CardSet' do
      user = create(:admin_user)

      sign_in(user)

      card_set = build(:card_set)

      CardSet.count.should eq(0)

      post :create, :card_set => create_params(card_set)

      response.status.should eq(302)

      response.should redirect_to(admin_card_sets_url)

      CardSet.count.should eq(1)
    end

    it 'should allow sysadmin users to create a new CardSet' do
      user = create(:sysadmin_user)

      sign_in(user)

      card_set = build(:card_set)

      CardSet.count.should eq(0)

      post :create, :card_set => create_params(card_set)

      response.status.should eq(302)

      response.should redirect_to(admin_card_sets_url)

      CardSet.count.should eq(1)
    end

    it 'should re-render the new action if the CardSet is invalid' do
      user = create(:sysadmin_user)

      sign_in(user)

      card_set = build(:card_set, :name => '')

      CardSet.count.should eq(0)

      post :create, :card_set => create_params(card_set)

      response.status.should eq(200)

      response.should render_template('new')

      CardSet.count.should eq(0)
    end
  end

  context '#edit' do
    it 'should not be visible if not signed in' do
      card_set = create(:card_set)

      get :edit, :id => card_set.id

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)
    end

    it 'should not be visible to read_only users' do
      user = create(:read_only_user)

      sign_in(user)

      card_set = create(:card_set)

      get :edit, :id => card_set.id

      response.status.should eq(302)

      response.should redirect_to(root_url)
    end

    it 'should be visible to admin users' do
      user = create(:admin_user)

      sign_in(user)

      card_set = create(:card_set)

      get :edit, :id => card_set.id

      response.status.should eq(200)

      response.should render_template('edit')
    end

    it 'should be visible to sysadmin users' do
      user = create(:sysadmin_user)

      sign_in(user)

      card_set = create(:card_set)

      get :edit, :id => card_set.id

      response.status.should eq(200)

      response.should render_template('edit')
    end

    it 'should redirect to the CardSet index if the requested CardSet does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      get :edit, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_card_sets_url)
    end
  end

  context '#update' do
    it 'should not edit an existing CardSet if not signed in' do
      card_set = create(:card_set)

      params = create_params(card_set)

      params[:name] = 'New CardSet Name'

      put :update, :id => card_set.id, :card_set => params

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)

      updated_card_set = CardSet.where(:id => card_set.id).first

      updated_card_set.name.should eq(card_set.name)

      updated_card_set.name.should_not eq('New CardSet Name')
    end

    it 'should not allow read_only users to edit an existing CardSet' do
      user = create(:read_only_user)

      sign_in(user)

      card_set = create(:card_set)

      params = create_params(card_set)

      params[:name] = 'New CardSet Name'

      put :update, :id => card_set.id, :card_set => params

      response.status.should eq(302)

      response.should redirect_to(root_url)

      updated_card_set = CardSet.where(:id => card_set.id).first

      updated_card_set.name.should eq(card_set.name)

      updated_card_set.name.should_not eq('New CardSet Name')
    end

    it 'should allow admin users to edit an existing CardSet' do
      user = create(:admin_user)

      sign_in(user)

      card_set = create(:card_set)

      params = create_params(card_set)

      params[:name] = 'New CardSet Name'

      put :update, :id => card_set.id, :card_set => params

      response.status.should eq(302)

      response.should redirect_to(edit_admin_card_set_url(:id => card_set.id))

      updated_card_set = CardSet.where(:id => card_set.id).first

      updated_card_set.name.should_not eq(card_set.name)

      updated_card_set.name.should eq('New CardSet Name')
    end

    it 'should allow sysadmin users to edit an existing CardSet' do
      user = create(:sysadmin_user)

      sign_in(user)

      card_set = create(:card_set)

      params = create_params(card_set)

      params[:name] = 'New CardSet Name'

      put :update, :id => card_set.id, :card_set => params

      response.status.should eq(302)

      response.should redirect_to(edit_admin_card_set_url(:id => card_set.id))

      updated_card_set = CardSet.where(:id => card_set.id).first

      updated_card_set.name.should_not eq(card_set.name)

      updated_card_set.name.should eq('New CardSet Name')
    end

    it 'should redirect to the CardSet index if the requested CardSet does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      put :update, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_card_sets_url)
    end

    it 'should re-render the edit action if the CardSet is invalid' do
      user = create(:sysadmin_user)

      sign_in(user)

      card_set = create(:card_set)

      params = create_params(card_set)

      params[:name] = ''

      put :update, :id => card_set.id, :card_set => params

      response.status.should eq(200)

      response.should render_template('edit')

      updated_card_set = CardSet.where(:id => card_set.id).first

      updated_card_set.name.should eq(card_set.name)

      updated_card_set.name.should_not eq('')
    end
  end

  context '#destroy' do
    it 'should not delete an existing CardSet if not signed in' do
      card_set = create(:card_set)

      CardSet.count.should eq(1)

      delete :destroy, :id => card_set.id

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)

      CardSet.count.should eq(1)
    end

    it 'should not allow read_only users to delete an existing CardSet' do
      user = create(:read_only_user)

      sign_in(user)

      card_set = create(:card_set)

      CardSet.count.should eq(1)

      delete :destroy, :id => card_set.id

      response.status.should eq(302)

      response.should redirect_to(root_url)

      CardSet.count.should eq(1)
    end

    it 'should allow admin users to delete an existing CardSet' do
      user = create(:admin_user)

      sign_in(user)

      card_set = create(:card_set)

      CardSet.count.should eq(1)

      delete :destroy, :id => card_set.id

      response.status.should eq(302)

      response.should redirect_to(admin_card_sets_url)

      CardSet.count.should eq(0)
    end

    it 'should allow sysadmin users to delete an existing CardSet' do
      user = create(:sysadmin_user)

      sign_in(user)

      card_set = create(:card_set)

      CardSet.count.should eq(1)

      delete :destroy, :id => card_set.id

      response.status.should eq(302)

      response.should redirect_to(admin_card_sets_url)

      CardSet.count.should eq(0)
    end

    it 'should redirect to the CardSet index if the requested CardSet does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      delete :destroy, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_card_sets_url)
    end
  end
end
