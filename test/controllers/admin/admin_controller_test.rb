# frozen_string_literal: true

require 'test_helper'

module Admin
  class AdminControllerTest < ActionDispatch::IntegrationTest
    let(:admin) { users(:user1) }

    setup do
      admin.add_role(:user)
      admin.add_role(:admin)
    end

    describe '#index' do
      it 'should show the index page' do
        sign_in(admin)

        get admin_root_url

        assert_response :ok
      end
    end
  end
end
