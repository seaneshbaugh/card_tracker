# frozen_string_literal: true

require 'test_helper'

class CardTest < ActiveSupport::TestCase
  let(:card) { cards(:abyssal_specter) }

  describe 'associations' do
    it 'belongs to card_set' do
      card.must belong_to(:card_set)
    end

    it 'belongs to layout' do
      card.must belong_to(:layout).with_foreign_key(:layout_code).inverse_of(:cards).with_primary_key(:layout_code)
    end

    it 'belongs to rarity' do
      card.must belong_to(:rarity).with_foreign_key(:rarity_code).inverse_of(:cards).with_primary_key(:rarity_code)
    end

    it 'has many card_colorings' do
      card.must have_many(:card_colorings).dependent(:restrict_with_exception)
    end

    it 'has many card_super_typings' do
      card.must have_many(:card_super_typings).dependent(:restrict_with_exception)
    end

    it 'has many card_typings' do
      card.must have_many(:card_typings).dependent(:restrict_with_exception)
    end

    it 'has many card_sub_typings' do
      card.must have_many(:card_sub_typings).dependent(:restrict_with_exception)
    end

    it 'has many card_partssub_typings' do
      card.must have_many(:card_parts).dependent(:restrict_with_exception)
    end

    it 'has many collections' do
      card.must have_many(:collections).dependent(:restrict_with_exception)
    end

    it 'has many colors through card_colorings' do
      card.must have_many(:colors).through(:card_colorings).with_foreign_key(:color_code)
    end

    it 'has many card_super_types through card_super_typings' do
      card.must have_many(:card_super_types).through(:card_super_typings).with_foreign_key(:card_super_type_code)
    end

    it 'has many card_types through card_typings' do
      card.must have_many(:card_types).through(:card_typings).with_foreign_key(:card_type_code)
    end

    it 'has many card_sub_types through card_sub_typings' do
      card.must have_many(:card_sub_types).through(:card_sub_typings).with_foreign_key(:card_sub_type_code)
    end

    it 'has many users through collections' do
      card.must have_many(:users).through(:collections)
    end
  end

  describe 'validations' do
    describe 'name' do
      it 'validates presence of name' do
        card.must validate_presence_of(:name)
      end
    end
  end
end
