# frozen_string_literal: true

require 'test_helper'

class CollectionTest < ActiveSupport::TestCase
  let(:card) { cards(:abyssal_specter)}
  let(:user) { users(:user1) }
  let(:card_list) { CardList.create(user: user, name: 'Test', have: true, order: 0, default: true) }
  let(:collection) { Collection.create(card: card, user: user, card_list: card_list, quantity: 1) }

  describe 'associations' do
    it 'belongs to card' do
      collection.must belong_to(:card)
    end

    it 'belongs to user' do
      collection.must belong_to(:user)
    end

    it 'belongs to card_list' do
      collection.must belong_to(:card_list)
    end
  end

  describe 'validations' do
    describe 'quantity' do
      it 'validates numericality of quantity' do
        collection.must validate_numericality_of(:quantity)
      end

      it 'validates presence of quantity' do
        collection.must validate_presence_of(:quantity)
      end
    end

    describe 'card_is_addible?' do
      it 'validates that the card is addible' do
        card.layout_code = 'MELD'
        card.card_number = '1b'

        refute card.addible?

        collection.validate

        refute collection.valid?

        collection.errors.full_messages.must_include 'Card is the result of a meld and cannot be directly added to your collection'
      end
    end
  end

  describe '#cards?' do
    context 'when quantity is 0' do
      it 'returns false' do
        collection.quantity = 0

        collection.cards?.must_equal false
      end
    end

    context 'when quantity is greater than 0' do
      it 'returns true' do
        collection.quantity = 4

        collection.cards?.must_equal true
      end
    end
  end
end
