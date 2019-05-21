# frozen_string_literal: true

require 'test_helper'

class CardPartSuperTypingTest < ActiveSupport::TestCase
  let(:card_part_super_typing) { CardPartSuperTyping.new }

  describe 'associations' do
    it 'belongs to card_part' do
      card_part_super_typing.must belong_to(:card_part).inverse_of(:card_part_super_typings)
    end

    it 'belongs to card_super_type' do
      card_part_super_typing.must belong_to(:card_super_type).with_foreign_key(:card_super_type_code).inverse_of(:card_part_super_typings).with_primary_key(:card_super_type_code)
    end
  end
end
