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

    it 'has many card_super_types through card_part_super_typings' do
      card_part.must have_many(:card_super_types).through(:card_part_super_typings).with_foreign_key(:card_super_type_code)
    end
  end
end
