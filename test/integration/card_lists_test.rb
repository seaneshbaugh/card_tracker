# frozen_string_literal: true

class CardListsTest < ActionDispatch::IntegrationTest
  let(:user) { users(:user1) }

  setup do
    user.card_lists << CardList.create(name: 'Have', have: true, default: true)
  end

  test 'user can view their card lists' do
    user = users(:user1)

    sign_in user

    get root_path

    assert_response :success

    assert_select 'div.card-lists'
  end
end
