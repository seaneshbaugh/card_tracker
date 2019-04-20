# frozen_string_literal: true

require 'test_helper'

class CardTest < ActiveSupport::TestCase
  let(:card_block_type) { CardBlockType.create(name: 'Core') }
  let(:card_block) { CardBlock.create(card_block_type: card_block_type, name: 'Core') }
  let(:card_set) { CardSet.create(card_block: card_block, name: 'Limited Edition Alpha', code: 'LEA', release_date: Date.parse('1993-08-05')) }

  describe 'associations' do
    describe 'rarity' do
      let(:rarity) { rarities(:rare) }

      it 'associates the rarity using the non-standard primary key' do
        card = Card.create(name: 'Black Lotus', card_set: card_set, rarity: rarity, multiverse_id: '1')

        assert card.valid?

        assert card.persisted?

        assert card.rarity_code == rarity.rarity_code

        assert card.rarity == rarity
      end
    end
  end
end
