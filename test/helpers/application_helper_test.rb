# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  describe '#present' do
    it 'returns a presenter for the given model' do
      user = users(:user1)

      user_presenter = present(user)

      user_presenter.must_be_kind_of(UserPresenter)

      user_presenter.instance_variable_get(:@object).must_equal user
    end
  end
end
