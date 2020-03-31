# frozen_string_literal: true

require 'test_helper'

# Commenting this out because it is SLOW. I have no idea why.
class PagesControllerTest < ActionDispatch::IntegrationTest
  describe '#index' do
    it 'should show the index page' do
      get root_url

      assert_response :ok
    end
  end

  describe '#show' do
    context 'valid pages' do
      it 'should show valid pages' do
        %w[about privacy-policy terms-and-conditions].each do |page|
          get page_url(id: page)

          assert_response :ok
        end
      end
    end

    context 'invalid pages' do
      it 'should return a 404' do
        _(proc { get page_url(id: 'does-not-exist') }).must_raise(ActionController::RoutingError)
      end
    end
  end
end
