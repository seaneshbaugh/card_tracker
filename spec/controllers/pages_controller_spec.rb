require 'spec_helper'

describe PagesController do
  include Devise::TestHelpers
  include ControllerSupport

  context '#index' do
    it 'should call the index action and render the index template' do
      get :index

      response.status.should eq(200)

      response.should render_template('index')
    end
  end

  context '#show' do
    it 'should show the About page' do
      get :show, :id => 'about'

      response.status.should eq(200)

      response.should render_template('pages/about')
    end

    it 'should show the Privacy Policy page' do
      get :show, :id => 'privacy-policy'

      response.status.should eq(200)

      response.should render_template('pages/')
    end

    it 'should show the Terms and Conditions page' do
      get :show, :id => 'terms-and-conditions'

      response.status.should eq(200)

      response.should render_template('pages/terms-and-conditions')
    end
  end
end
