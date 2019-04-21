# frozen_string_literal: true

require 'test_helper'

class CardTest < ActiveSupport::TestCase
  let(:card_set) { card_sets(:ice_age) }
  
  describe 'associations' do
    describe 'rarity' do
      let(:rarity) { rarities(:rare) }

      it 'associates the rarity using the non-standard primary key' do
        card = Card.create(name: 'Black Lotus', card_set: card_set, rarity: rarity, multiverse_id: '1', card_text: '', flavor_text: '')

        assert card.valid?

        assert card.persisted?

        assert card.rarity_code == rarity.rarity_code

        assert card.rarity == rarity
      end
    end
  end
end
