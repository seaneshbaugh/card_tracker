# frozen_string_literal: true

require 'test_helper'

class CardTest < ActiveSupport::TestCase
  let(:card) { cards(:abyssal_specter) }

  describe 'associations' do
    it 'belongs to card_set' do
      card.must belong_to(:card_set)
    end

    it 'belongs to layout' do
      card.must belong_to(:layout).with_foreign_key(:layout_code).inverse_of(:cards).with_primary_key(:layout_code)
    end

    it 'belongs to rarity' do
      card.must belong_to(:rarity).with_foreign_key(:rarity_code).inverse_of(:cards).with_primary_key(:rarity_code)
    end

    it 'has many card_colorings' do
      card.must have_many(:card_colorings).dependent(:restrict_with_exception)
    end

    it 'has many card_super_typings' do
      card.must have_many(:card_super_typings).dependent(:restrict_with_exception)
    end

    it 'has many card_typings' do
      card.must have_many(:card_typings).dependent(:restrict_with_exception)
    end

    it 'has many card_sub_typings' do
      card.must have_many(:card_sub_typings).dependent(:restrict_with_exception)
    end

    it 'has many card_partssub_typings' do
      card.must have_many(:card_parts).dependent(:restrict_with_exception)
    end

    it 'has many collections' do
      card.must have_many(:collections).dependent(:restrict_with_exception)
    end

    it 'has many colors through card_colorings' do
      card.must have_many(:colors).through(:card_colorings).with_foreign_key(:color_code)
    end

    it 'has many card_super_types through card_super_typings' do
      card.must have_many(:card_super_types).through(:card_super_typings).with_foreign_key(:card_super_type_code)
    end

    it 'has many card_types through card_typings' do
      card.must have_many(:card_types).through(:card_typings).with_foreign_key(:card_type_code)
    end

    it 'has many card_sub_types through card_sub_typings' do
      card.must have_many(:card_sub_types).through(:card_sub_typings).with_foreign_key(:card_sub_type_code)
    end

    it 'has many users through collections' do
      card.must have_many(:users).through(:collections)
    end
  end

  describe 'validations' do
    describe 'name' do
      it 'validates presence of name' do
        card.must validate_presence_of(:name)
      end
    end

    describe 'type_text' do
      it 'validates presence of type_text' do
        card.must validate_presence_of(:type_text)
      end
    end

    describe 'card_number' do
      it 'validates presence of card_number' do
        card.must validate_presence_of(:card_number)
      end
    end

    describe 'artist' do
      it 'validates presence of artist' do
        card.must validate_presence_of(:artist)
      end
    end
  end

  describe '#white?' do
    context 'when colors do not include white' do
      it 'returns false' do
        card.colors = Color.where(color_code: %w[U B R G])

        card.white?.must_equal false
      end
    end

    context 'when colors do include white' do
      it 'returns true' do
        card.colors = Color.where(color_code: %w[W U B R G])

        card.white?.must_equal true
      end
    end
  end

  describe '#blue?' do
    context 'when colors do not include blue' do
      it 'returns false' do
        card.colors = Color.where(color_code: %w[W B R G])

        card.blue?.must_equal false
      end
    end

    context 'when colors do include blue' do
      it 'returns true' do
        card.colors = Color.where(color_code: %w[W U B R G])

        card.blue?.must_equal true
      end
    end
  end

  describe '#black?' do
    context 'when colors do not include black' do
      it 'returns false' do
        card.colors = Color.where(color_code: %w[W U R G])

        card.black?.must_equal false
      end
    end

    context 'when colors do include black' do
      it 'returns true' do
        card.colors = Color.where(color_code: %w[W U B R G])

        card.black?.must_equal true
      end
    end
  end

  describe '#red?' do
    context 'when colors do not include red' do
      it 'returns false' do
        card.colors = Color.where(color_code: %w[W U B G])

        card.red?.must_equal false
      end
    end

    context 'when colors do include red' do
      it 'returns true' do
        card.colors = Color.where(color_code: %w[W U B R G])

        card.red?.must_equal true
      end
    end
  end

  describe '#green?' do
    context 'when colors do not include green' do
      it 'returns false' do
        card.colors = Color.where(color_code: %w[W U B R])

        card.green?.must_equal false
      end
    end

    context 'when colors do include green' do
      it 'returns true' do
        card.colors = Color.where(color_code: %w[W U B R G])

        card.green?.must_equal true
      end
    end
  end

  describe '#colorless?' do
    describe 'when no colors are present' do

      it 'returns true' do
        card.colors = []

        card.colorless?.must_equal true
      end
    end

    context 'when one color is present' do
      it 'returns false' do
        card.colors = Color.where(color_code: 'B')

        card.colorless?.must_equal false
      end
    end

    context 'when multiple colors are present' do
      it 'returns false' do
        card.colors = Color.where(color_code: %w[W B U])

        card.colorless?.must_equal false
      end
    end
  end

  describe '#monocolored?' do
    context 'when no colors are present' do
      it 'returns false' do
        card.colors = []

        card.monocolored?.must_equal false
      end
    end

    context 'when one color is present' do
      it 'returns true' do
        card.colors = Color.where(color_code: 'B')

        card.monocolored?.must_equal true
      end
    end

    context 'when multiple colors are present' do
      it 'returns false' do
        card.colors = Color.where(color_code: %w[W B U])

        card.monocolored?.must_equal false
      end
    end
  end

  describe '#multicolored?' do
    context 'when no colors are present' do
      it 'returns true' do
        card.colors = []

        card.multicolored?.must_equal false
      end
    end

    context 'when one color is present' do
      it 'returns false' do
        card.colors = Color.where(color_code: 'B')

        card.multicolored?.must_equal false
      end
    end

    context 'when multiple colors are present' do
      it 'returns true' do
        card.colors = Color.where(color_code: %w[W B U])

        card.multicolored?.must_equal true
      end
    end
  end

  describe '#land?' do
    context 'when land type is not present' do
      it 'returns false' do
        card.card_types = CardType.where(card_type_code: 'CREATURE')

        card.land?.must_equal false
      end
    end

    context 'when land type is present' do
      it 'returns true' do
        card.card_types = CardType.where(card_type_code: 'LAND')

        card.land?.must_equal true
      end
    end
  end

  describe '#collection_for' do
    let(:user) { users(:user1) }
    let(:card_list) { CardList.create(user: user, name: 'Have') }
    let(:collection) { Collection.create(card_list: card_list, user: user, card: card) }

    context 'when collections have not been previously loaded' do
      it 'returns the collection for user\'s card list' do
        collection

        card.collection_for(user, card_list).must_equal collection
      end
    end

    context 'when collections have been previously loaded' do
      it 'returns the collection for user\'s card list' do
        collection

        card.collections.length.must_equal 1

        card.collection_for(user, card_list).must_equal collection
      end
    end
  end

  describe '#other_versions' do
    let(:other_card) { Card.create(name: card.name, card_set: card_sets(:mirage), layout_code: card.layout_code, rarity_code: card.rarity_code, type_text: card.type_text, card_number: '1', artist: card.artist) }

    it 'returns other versions of the same card' do
      other_card

      card.other_versions.must_equal [other_card]
    end
  end
end
