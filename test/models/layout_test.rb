# frozen_string_literal: true

require 'test_helper'

class LayoutTest < ActiveSupport::TestCase
  let(:layout) { Layout.new }

  describe 'associations' do
    it 'has many cards' do
      layout.must have_many(:cards).dependent(:restrict_with_exception).with_foreign_key(:layout_code).inverse_of(:layout)
    end
  end

  describe 'validations' do
    describe 'layout_code' do
      it 'validates presence of layout_code' do
        layout.must validate_presence_of(:layout_code)
      end

      it 'validates uniqueness of layout_code' do
        layout.must validate_uniqueness_of(:layout_code)
      end
    end

    describe 'name' do
      it 'validates presence of name' do
        layout.must validate_presence_of(:name)
      end

      it 'validates uniqueness of name' do
        layout.must validate_uniqueness_of(:name)
      end
    end
  end
end
