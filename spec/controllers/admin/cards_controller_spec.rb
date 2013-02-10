require 'spec_helper'

describe Admin::CardsController do
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
      cards = create(:card)

      get :show, :id => cards.id

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)
    end

    it 'should not be visible to read_only users' do
      user = create(:read_only_user)

      sign_in(user)

      cards = create(:card)

      get :show, :id => cards.id

      response.status.should eq(302)

      response.should redirect_to(root_url)
    end

    it 'should be visible to admin users' do
      user = create(:admin_user)

      sign_in(user)

      cards = create(:card)

      get :show, :id => cards.id

      response.status.should eq(200)

      response.should render_template('show')
    end

    it 'should be visible to sysadmin users' do
      user = create(:sysadmin_user)

      sign_in(user)

      cards = create(:card)

      get :show, :id => cards.id

      response.status.should eq(200)

      response.should render_template('show')
    end

    it 'should redirect to the Card index if the requested Card does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      get :show, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_cards_url)
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
    it 'should not create a new Card if not signed in' do
      card = build(:card)

      Card.count.should eq(0)

      post :create, :card => create_params(card)

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)

      Card.count.should eq(0)
    end

    it 'should not allow read_only users to create a new Card' do
      user = create(:read_only_user)

      sign_in(user)

      card = build(:card)

      Card.count.should eq(0)

      post :create, :card => create_params(card)

      response.status.should eq(302)

      response.should redirect_to(root_url)

      Card.count.should eq(0)
    end

    it 'should allow admin users to create a new Card' do
      user = create(:admin_user)

      sign_in(user)

      card = build(:card)

      Card.count.should eq(0)

      post :create, :card => create_params(card)

      response.status.should eq(302)

      response.should redirect_to(admin_cards_url)

      Card.count.should eq(1)
    end

    it 'should allow sysadmin users to create a new Card' do
      user = create(:sysadmin_user)

      sign_in(user)

      card = build(:card)

      Card.count.should eq(0)

      post :create, :card => create_params(card)

      response.status.should eq(302)

      response.should redirect_to(admin_cards_url)

      Card.count.should eq(1)
    end

    it 'should re-render the new action if the Card is invalid' do
      user = create(:sysadmin_user)

      sign_in(user)

      card = build(:card, :name => '')

      Card.count.should eq(0)

      post :create, :card => create_params(card)

      response.status.should eq(200)

      response.should render_template('new')

      Card.count.should eq(0)
    end
  end

  context '#edit' do
    it 'should not be visible if not signed in' do
      card = create(:card)

      get :edit, :id => card.id

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)
    end

    it 'should not be visible to read_only users' do
      user = create(:read_only_user)

      sign_in(user)

      card = create(:card)

      get :edit, :id => card.id

      response.status.should eq(302)

      response.should redirect_to(root_url)
    end

    it 'should be visible to admin users' do
      user = create(:admin_user)

      sign_in(user)

      card = create(:card)

      get :edit, :id => card.id

      response.status.should eq(200)

      response.should render_template('edit')
    end

    it 'should be visible to sysadmin users' do
      user = create(:sysadmin_user)

      sign_in(user)

      card = create(:card)

      get :edit, :id => card.id

      response.status.should eq(200)

      response.should render_template('edit')
    end

    it 'should redirect to the Card index if the requested Card does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      get :edit, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_cards_url)
    end
  end

  context '#update' do
    it 'should not edit an existing Card if not signed in' do
      card = create(:card)

      params = create_params(card)

      params[:name] = 'New Card Name'

      put :update, :id => card.id, :card => params

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)

      updated_card = Card.where(:id => card.id).first

      updated_card.name.should eq(card.name)

      updated_card.name.should_not eq('New Card Name')
    end

    it 'should not allow read_only users to edit an existing Card' do
      user = create(:read_only_user)

      sign_in(user)

      card = create(:card)

      params = create_params(card)

      params[:name] = 'New Card Name'

      put :update, :id => card.id, :card => params

      response.status.should eq(302)

      response.should redirect_to(root_url)

      updated_card = Card.where(:id => card.id).first

      updated_card.name.should eq(card.name)

      updated_card.name.should_not eq('New Card Name')
    end

    it 'should allow admin users to edit an existing Card' do
      user = create(:admin_user)

      sign_in(user)

      card = create(:card)

      params = create_params(card)

      params[:name] = 'New Card Name'

      put :update, :id => card.id, :card => params

      response.status.should eq(302)

      response.should redirect_to(edit_admin_card_url(:id => card.id))

      updated_card = Card.where(:id => card.id).first

      updated_card.name.should_not eq(card.name)

      updated_card.name.should eq('New Card Name')
    end

    it 'should allow sysadmin users to edit an existing Card' do
      user = create(:sysadmin_user)

      sign_in(user)

      card = create(:card)

      params = create_params(card)

      params[:name] = 'New Card Name'

      put :update, :id => card.id, :card => params

      response.status.should eq(302)

      response.should redirect_to(edit_admin_card_url(:id => card.id))

      updated_card = Card.where(:id => card.id).first

      updated_card.name.should_not eq(card.name)

      updated_card.name.should eq('New Card Name')
    end

    it 'should redirect to the Card index if the requested Card does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      put :update, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_cards_url)
    end

    it 'should re-render the edit action if the Card is invalid' do
      user = create(:sysadmin_user)

      sign_in(user)

      card = create(:card)

      params = create_params(card)

      params[:name] = ''

      put :update, :id => card.id, :card => params

      response.status.should eq(200)

      response.should render_template('edit')

      updated_card = Card.where(:id => card.id).first

      updated_card.name.should eq(card.name)

      updated_card.name.should_not eq('')
    end
  end

  context '#destroy' do
    it 'should not delete an existing Card if not signed in' do
      card = create(:card)

      Card.count.should eq(1)

      delete :destroy, :id => card.id

      response.status.should eq(302)

      response.should redirect_to(new_user_session_url)

      Card.count.should eq(1)
    end

    it 'should not allow read_only users to delete an existing Card' do
      user = create(:read_only_user)

      sign_in(user)

      card = create(:card)

      Card.count.should eq(1)

      delete :destroy, :id => card.id

      response.status.should eq(302)

      response.should redirect_to(root_url)

      Card.count.should eq(1)
    end

    it 'should allow admin users to delete an existing Card' do
      user = create(:admin_user)

      sign_in(user)

      card = create(:card)

      Card.count.should eq(1)

      delete :destroy, :id => card.id

      response.status.should eq(302)

      response.should redirect_to(admin_cards_url)

      Card.count.should eq(0)
    end

    it 'should allow sysadmin users to delete an existing Card' do
      user = create(:sysadmin_user)

      sign_in(user)

      card = create(:card)

      Card.count.should eq(1)

      delete :destroy, :id => card.id

      response.status.should eq(302)

      response.should redirect_to(admin_cards_url)

      Card.count.should eq(0)
    end

    it 'should redirect to the Card index if the requested Card does not exist' do
      user = create(:sysadmin_user)

      sign_in(user)

      delete :destroy, :id => 9999

      response.status.should eq(302)

      response.should redirect_to(admin_cards_url)
    end
  end
end
