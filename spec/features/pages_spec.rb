require 'spec_helper'

describe 'pages' do
  context '#index' do
    it 'should show the index page when not logged in' do
      visit root_path

      page.body.should have_selector('h1', :text => 'The Caves of Koilos')
    end

    it 'should not show the index page when logged in' do
      @user = create(:read_only_user)

      sign_in(@user)

      visit root_path

      page.body.should have_selector('h1', :text => 'Your Collection')
    end
  end
end
