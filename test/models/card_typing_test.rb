# frozen_string_literal: true

require 'test_helper'

class CardTypingTest < ActiveSupport::TestCase
  let(:card_typing) { CardTyping.new }

  describe 'associations' do
    it 'belongs to card' do
      card_typing.must belong_to(:card).inverse_of(:card_typings)
    end

    it 'belongs to card_type' do
      card_typing.must belong_to(:card_type).with_foreign_key(:card_type_code).inverse_of(:card_typings).with_primary_key(:card_type_code)
    end
  end
end
