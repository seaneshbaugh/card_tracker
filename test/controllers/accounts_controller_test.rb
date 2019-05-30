# frozen_string_literal: true

require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  let(:user) { users(:user1) }

  setup do
    sign_in(user)
  end

  describe '#show' do
    it 'should show the account page' do
      get account_url

      assert_response :ok
    end
  end

  describe '#edit' do
    it 'should show the account edit page' do
      get edit_account_url

      assert_response :ok
    end
  end

  describe '#update' do
    context 'with valid parameters' do
      it 'should update the current user and redirect to the edit account page' do
        patch account_url, params: { account: { first_name: 'Test' } }

        assert_response :see_other

        assert_redirected_to edit_account_url
      end
    end

    context 'with invalid parameters' do
      it 'should update the current user and redirect to the edit account page' do
        patch account_url, params: { account: { email: '' } }

        assert_response :unprocessable_entity
      end
    end
  end

  describe '#confirm_delete' do
    it 'should show the confirm destroy page' do
      get confirm_delete_account_url

      assert_response :ok
    end
  end

  describe '#destroy' do
    it 'should delete the current user and redirect to the root page' do
      delete account_url

      assert_response :see_other

      assert_redirected_to root_url
    end
  end
end
