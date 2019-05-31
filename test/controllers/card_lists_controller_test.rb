# frozen_string_literal: true

require 'test_helper'

class CardListsControllerTest < ActionDispatch::IntegrationTest
  let(:user) { users(:user1) }
  let(:card_list) { CardList.create(user: user, name: 'Have', default: true, have: true, order: 0) }

  setup do
    sign_in(user)
  end

  describe '#index' do
    it 'shows the index page' do
      get lists_url

      assert_response :ok
    end
  end

  describe '#show' do
    it 'shows the card list page' do
      get list_url(card_list)

      assert_response :ok
    end
  end

  describe '#new' do
    it 'shows the new card list page' do
      get new_list_url

      assert_response :ok
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      it 'should create a card list and redirect to the card lists index page' do
        post lists_url, params: { card_list: { name: 'New List', have: false, default: false, order: 100 } }

        assert_response :see_other

        assert_redirected_to root_url
      end
    end

    context 'with invalid parameters' do
      it 'should not create a card list and return a 422' do
        post lists_url, params: { card_list: { name: '', have: false, default: false, order: 100 } }

        assert_response :unprocessable_entity
      end
    end
  end

  describe '#edit' do
    it 'should show the edit card list page' do
      get edit_list_url(card_list)

      assert_response :ok
    end
  end

  describe '#update' do
    context 'with valid parameters' do
      it 'should update the card list and redirect to the card list show page' do
        patch list_url(card_list), params: { card_list: { name: 'Updated List' } }

        card_list.reload

        assert_response :see_other

        assert_redirected_to edit_list_url(card_list)
      end
    end

    context 'with invalid parameters' do
      it 'should not update the card list and return a 422' do
        patch list_url(card_list), params: { card_list: { name: '' } }

        assert_response :unprocessable_entity
      end
    end
  end

  describe '#reorder' do
    it 'should reorder the card lists and return a success message' do
      put reorder_lists_url, params: { card_lists_order: { card_list.id => 0 } }, as: :json

      assert_response :ok
    end
  end

  describe '#destroy' do
    it 'should delete the card list and redirect to the card lists index page' do
      delete list_url(card_list)

      assert_response :see_other

      assert_redirected_to root_url
    end
  end
end
