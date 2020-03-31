# frozen_string_literal: true

require 'test_helper'

class CardPartSubTypingTest < ActiveSupport::TestCase
  let(:card_part_sub_typing) { CardPartSubTyping.new }

  describe 'associations' do
    it 'belongs to card_part' do
      _(card_part_sub_typing).must(belong_to(:card_part).inverse_of(:card_part_sub_typings))
    end

    it 'belongs to card_sub_type' do
      _(card_part_sub_typing).must(belong_to(:card_sub_type).with_foreign_key(:card_sub_type_code).inverse_of(:card_part_sub_typings).with_primary_key(:card_sub_type_code))
    end
  end
end
