# frozen_string_literal: true

require 'test_helper'

class CardPartTypingTest < ActiveSupport::TestCase
  let(:card_part_typing) { CardPartTyping.new }

  describe 'associations' do
    it 'belongs to card_part' do
      _(card_part_typing).must(belong_to(:card_part).inverse_of(:card_part_typings))
    end

    it 'belongs to card_type' do
      _(card_part_typing).must(belong_to(:card_type).with_foreign_key(:card_type_code).with_primary_key(:card_type_code).inverse_of(:card_part_typings))
    end
  end
end
