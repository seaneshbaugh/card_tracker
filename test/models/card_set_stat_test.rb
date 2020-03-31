# frozen_string_literal: true

require 'test_helper'

class CardSetStatTest < ActiveSupport::TestCase
  let(:card) { cards(:abyssal_specter)}
  let(:user) { users(:user1) }
  let(:card_list) { CardList.create(user: user, name: 'Test', have: true, order: 0, default: true) }
  let(:collection) { Collection.create(card: card, user: user, card_list: card_list, quantity: 4) }
  let(:card_set_stat) { CardSetStat.new(card.card_set, user) }

  def setup
    collection
  end

  describe '#cards_in_set' do
    it 'returns the number of cards in a card set' do
      _(card_set_stat.cards_in_set).must_equal(1)
    end
  end

  describe '#unique_cards' do
    it 'returns the number of unique cards a user has in a card set' do
      _(card_set_stat.unique_cards).must_equal(1)
    end
  end

  describe '#unique_cards_in_list' do
    it 'returns the number of unique cards a user has in a card set in a list' do
      _(card_set_stat.unique_cards_in_list(card_list)).must_equal(1)
    end
  end

  describe '#total_cards' do
    it 'returns the total number of cards a user has in a card set' do
      _(card_set_stat.total_cards).must_equal(collection.quantity)
    end
  end

  describe '#total_cards_in_list' do
    it 'returns the total number of cards a user has in a card set in a list' do
      _(card_set_stat.total_cards_in_list(card_list)).must_equal(collection.quantity)
    end
  end

  describe '#percent_collected' do
    it 'returns the percentage of a set that has been collected by a user' do
      _(card_set_stat.percent_collected).must_equal(100)
    end
  end

  describe '#percent_collected_in_list' do
    it 'returns the percentage of a set that has been collected by a user in a list' do
      _(card_set_stat.percent_collected_in_list(card_list)).must_equal(100)
    end
  end

  describe '#basic_cards_in_set' do
    it 'returns the number of basic rarity cards in a set' do
      _(card_set_stat.basic_cards_in_set).must_equal(0)
    end
  end

  describe '#common_cards_in_set' do
    it 'returns the number of common rarity cards in a set' do
      _(card_set_stat.common_cards_in_set).must_equal(0)
    end
  end

  describe '#uncommon_cards_in_set' do
    it 'returns the number of uncommon rarity cards in a set' do
      _(card_set_stat.uncommon_cards_in_set).must_equal(1)
    end
  end

  describe '#rare_cards_in_set' do
    it 'returns the number of rare rarity cards in a set' do
      _(card_set_stat.rare_cards_in_set).must_equal(0)
    end
  end

  describe '#mythic_cards_in_set' do
    it 'returns the number of mythic rarity cards in a set' do
      _(card_set_stat.mythic_cards_in_set).must_equal(0)
    end
  end

  describe '#unique_basic_cards' do
    it 'returns the number of unique basic rarity cards a user has in a set' do
      _(card_set_stat.unique_basic_cards).must_equal(0)
    end
  end

  describe '#unique_common_cards' do
    it 'returns the number of unique common rarity cards a user has in a set' do
      _(card_set_stat.unique_common_cards).must_equal(0)
    end
  end

  describe '#unique_uncommon_cards' do
    it 'returns the number of unique uncommon rarity cards a user has in a set' do
      _(card_set_stat.unique_uncommon_cards).must_equal(1)
    end
  end

  describe '#unique_rare_cards' do
    it 'returns the number of unique rare rarity cards a user has in a set' do
      _(card_set_stat.unique_rare_cards).must_equal(0)
    end
  end

  describe '#unique_mythic_cards' do
    it 'returns the numbe of unique mythic rarity cards a user has in a set' do
      _(card_set_stat.unique_mythic_cards).must_equal(0)
    end
  end

  describe '#unique_basic_cards_in_list' do
    it 'returns the number of unique basic rarity cards a user has in a set in a list' do
      _(card_set_stat.unique_basic_cards_in_list(card_list)).must_equal(0)
    end
  end

  describe '#unique_common_cards_in_list' do
    it 'returns the number of unique common rarity cards a user has in a set in a list' do
      _(card_set_stat.unique_common_cards_in_list(card_list)).must_equal(0)
    end
  end

  describe '#unique_uncommon_cards_in_list' do
    it 'returns the number of unique uncommon rarity cards a user has in a set in a list' do
      _(card_set_stat.unique_uncommon_cards_in_list(card_list)).must_equal(1)
    end
  end

  describe '#unique_rare_cards_in_list' do
    it 'returns the number of unique rare rarity cards a user has in a set in a list' do
      _(card_set_stat.unique_rare_cards_in_list(card_list)).must_equal(0)
    end
  end

  describe '#unique_mythic_cards_in_list' do
    it 'returns the numbe of unique mythic rarity cards a user has in a set in a list' do
      _(card_set_stat.unique_mythic_cards_in_list(card_list)).must_equal(0)
    end
  end

  describe '#total_basic_cards' do
    it 'returns the total number of basic rarity cards a user has in a set' do
      _(card_set_stat.total_basic_cards).must_equal(0)
    end
  end

  describe '#total_common_cards' do
    it 'returns the total number of common rarity cards a user has in a set' do
      _(card_set_stat.total_common_cards).must_equal(0)
    end
  end

  describe '#total_uncommon_cards' do
    it 'returns the total number of uncommon rarity cards a user has in a set' do
      _(card_set_stat.total_uncommon_cards).must_equal(4)
    end
  end

  describe '#total_rare_cards' do
    it 'returns the total number of rare rarity cards a user has in a set' do
      _(card_set_stat.total_rare_cards).must_equal(0)
    end
  end

  describe '#total_mythic_cards' do
    it 'returns the total number of mythic rarity cards a user has in a set' do
      _(card_set_stat.total_mythic_cards).must_equal(0)
    end
  end

  describe '#total_basic_cards_in_list' do
    it 'returns the total number of basic rarity cards a user has in a set in a list' do
      _(card_set_stat.total_basic_cards_in_list(card_list)).must_equal(0)
    end
  end

  describe '#total_common_cards_in_list' do
    it 'returns the total number of common rarity cards a user has in a set in a list' do
      _(card_set_stat.total_common_cards_in_list(card_list)).must_equal(0)
    end
  end

  describe '#total_uncommon_cards_in_list' do
    it 'returns the total number of uncommon rarity cards a user has in a set in a list' do
      _(card_set_stat.total_uncommon_cards_in_list(card_list)).must_equal(4)
    end
  end

  describe '#total_rare_cards_in_list' do
    it 'returns the total number of rare rarity cards a user has in a set in a list' do
      _(card_set_stat.total_rare_cards_in_list(card_list)).must_equal(0)
    end
  end

  describe '#total_mythic_cards_in_list' do
    it 'returns the total number of mythic rarity cards a user has in a set in a list' do
      _(card_set_stat.total_mythic_cards_in_list(card_list)).must_equal(0)
    end
  end
end
