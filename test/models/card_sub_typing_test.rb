# frozen_string_literal: true

require 'test_helper'

class CardSubTypingTest < ActiveSupport::TestCase
  let(:card_sub_typing) { CardSubTyping.new }

  describe 'associations' do
    it 'should belong to card' do
      _(card_sub_typing).must(belong_to(:card).inverse_of(:card_sub_typings))
    end

    it 'should belong to card_sub_type' do
      _(card_sub_typing).must(belong_to(:card_sub_type).with_foreign_key(:card_sub_type_code).inverse_of(:card_sub_typings).with_primary_key(:card_sub_type_code))
    end
  end
end
