# frozen_string_literal: true

require 'test_helper'

class CollectionTest < ActiveSupport::TestCase
  let(:card) { cards(:abyssal_specter)}
  let(:user) { users(:user1) }
  let(:card_list) { CardList.create(user: user, name: 'Test', have: true, order: 0, default: true) }
  let(:collection) { Collection.create(card: card, user: user, card_list: card_list, quantity: 1) }

  describe 'associations' do
    it 'belongs to card' do
      _(collection).must(belong_to(:card))
    end

    it 'belongs to user' do
      _(collection).must(belong_to(:user))
    end

    it 'belongs to card_list' do
      _(collection).must(belong_to(:card_list))
    end
  end

  describe 'validations' do
    describe 'quantity' do
      it 'validates numericality of quantity' do
        _(collection).must(validate_numericality_of(:quantity))
      end

      it 'validates presence of quantity' do
        _(collection).must(validate_presence_of(:quantity))
      end
    end

    describe 'card_is_addible?' do
      it 'validates that the card is addible' do
        card.layout_code = 'MELD'
        card.card_number = '1b'

        _(card.addible?).must_equal(false)

        collection.validate

        _(collection.valid?).must_equal(false)

        _(collection.errors.full_messages).must_include('Card is the result of a meld and cannot be directly added to your collection')
      end
    end
  end

  describe '#cards?' do
    context 'when quantity is 0' do
      it 'returns false' do
        collection.quantity = 0

        _(collection.cards?).must_equal(false)
      end
    end

    context 'when quantity is greater than 0' do
      it 'returns true' do
        collection.quantity = 4

        _(collection.cards?).must_equal(true)
      end
    end
  end
end
