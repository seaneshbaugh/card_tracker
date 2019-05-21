# frozen_string_literal: true

require 'test_helper'

class CardSubTypeTest < ActiveSupport::TestCase
  let(:card_sub_type) { CardSubType.new }

  describe 'associations' do
    it 'has many card_sub_typings' do
      card_sub_type.must have_many(:card_sub_typings).dependent(:restrict_with_exception).inverse_of(:card_sub_type)
    end

    it 'has many cards through card_sub_typings' do
      card_sub_type.must have_many(:cards).through(:card_sub_typings).inverse_of(:card_sub_types)
    end
  end

  describe 'validations' do
    describe 'card_sub_type_code' do
      it 'validates presence of card_sub_type_code' do
        card_sub_type.must validate_presence_of(:card_sub_type_code)
      end

      it 'validates uniqueness of card_sub_type_code' do
        card_sub_type.must validate_uniqueness_of(:card_sub_type_code)
      end
    end

    describe 'name' do
      it 'validates presence of name' do
        card_sub_type.must validate_presence_of(:name)
      end

      it 'validates uniqueness of name' do
        card_sub_type.must validate_uniqueness_of(:name)
      end
    end
  end
end
