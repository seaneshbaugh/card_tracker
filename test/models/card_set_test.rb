# frozen_string_literal: true

require 'test_helper'

class CardSetTest < ActiveSupport::TestCase
  let(:card_set) { card_sets(:ice_age) }

  describe 'associations' do
    it 'belongs to card_set_type' do
      card_set.must belong_to(:card_set_type).with_foreign_key(:card_set_type_code).inverse_of(:card_sets).with_primary_key(:card_set_type_code)
    end

    it 'belongs to card_block' do
      card_set.must belong_to(:card_block).inverse_of(:card_sets).optional
    end

    it 'belongs to parent' do
      card_set.must belong_to(:parent).class_name('CardSet').inverse_of(:children).optional
    end

    it 'has many cards' do
      card_set.must have_many(:cards).dependent(:restrict_with_exception).inverse_of(:card_set)
    end

    it 'has many children' do
      card_set.must have_many(:children).class_name('CardSet').dependent(:restrict_with_exception).inverse_of(:parent)
    end
  end

  describe 'validations' do
    describe 'name' do
      it 'validates presence of name' do
        card_set.must validate_presence_of(:name)
      end

      it 'validates uniqueness of name' do
        card_set.must validate_uniqueness_of(:name)
      end
    end

    describe 'code' do
      it 'validates presence of code' do
        card_set.must validate_presence_of(:code)
      end

      it 'validates uniqueness of code' do
        card_set.must validate_uniqueness_of(:code)
      end
    end
  end
end
