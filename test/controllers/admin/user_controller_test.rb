# frozen_string_literal: true

require 'test_helper'

module Admin
  class UserControllerTest < ActionDispatch::IntegrationTest
    let(:admin) { users(:user1) }
    let(:user) { users(:user2) }

    setup do
      admin.add_role(:user)
      admin.add_role(:admin)

      user.add_role(:user)
    end

    describe '#index' do
      it 'should show the index page' do
        sign_in(admin)

        get admin_users_url

        assert_response :ok
      end
    end
  end
end
