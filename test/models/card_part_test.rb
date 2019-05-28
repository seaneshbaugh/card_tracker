# frozen_string_literal: true

require 'test_helper'

class CardPartTest < ActiveSupport::TestCase
  let(:card_part) { CardPart.new }

  describe 'associations' do
    it 'belogs to card' do
      card_part.must belong_to(:card).inverse_of(:card_parts)
    end

    it 'has many card_part_super_typings' do
      card_part.must have_many(:card_part_super_typings).dependent(:restrict_with_exception).inverse_of(:card_part)
    end

    it 'has many card_part_typings' do
      card_part.must have_many(:card_part_typings).dependent(:restrict_with_exception).inverse_of(:card_part)
    end

    it 'has many card_super_types through card_part_super_typings' do
      card_part.must have_many(:card_super_types).through(:card_part_super_typings).with_foreign_key(:card_super_type_code).inverse_of(:card_parts)
    end

    it 'has many card_types through card_part_typings' do
      card_part.must have_many(:card_types).through(:card_part_typings).with_foreign_key(:card_type_code).inverse_of(:card_parts)
    end
  end

  describe 'validations' do
    describe 'name' do
      it 'validates presence of name' do
        card_part.must validate_presence_of(:name)
      end
    end

    describe 'side' do
      it 'validates inclusion of side in ["a", "b", "c"]' do
        card_part.must validate_inclusion_of(:side).in_array(%w[a b c])
      end

      it 'validates presence of side' do
        card_part.must validate_presence_of(:side)
      end
    end
  end
end
