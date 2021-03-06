# frozen_string_literal: true

require 'test_helper'

class CardListTest < ActiveSupport::TestCase
  let(:user) { users(:user1) }
  let(:card_list) { CardList.new(user: user) }

  describe 'associations' do
    it 'it belongs to user' do
      _(card_list).must(belong_to(:user).inverse_of(:card_lists))
    end

    it 'has many collections' do
      _(card_list).must(have_many(:collections).dependent(:destroy).inverse_of(:card_list))
    end

    it 'has many cards through collections' do
      _(card_list).must(have_many(:cards).through(:collections).inverse_of(:card_list))
    end
  end

  describe 'validations' do
    describe 'name' do
      it 'validates presence of name' do
        _(card_list).must(validate_presence_of(:name))
      end

      it 'validates uniqueness of name scopped to the user' do
        _(card_list).must(validate_uniqueness_of(:name).scoped_to(:user_id))
      end
    end

    describe 'order' do
      it 'validates numericality of order' do
        _(card_list).must(validate_numericality_of(:order).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(2_147_483_647))
      end

      it 'validates presence of order' do
        _(card_list).must(validate_presence_of(:order))
      end
    end
  end

  describe '#ensure_only_one_default' do
    it 'ensures that only one CardList can have the default flag for a user' do
      card_list_1 = CardList.create(user: user, name: 'List 1', have: true, order: 0, default: true)
      card_list_2 = CardList.create(user: user, name: 'List 2', have: true, order: 1, default: false)
      card_list_3 = CardList.create(user: user, name: 'List 3', have: true, order: 2, default: false)

      card_list_2.default = true

      card_list_2.save

      card_list_1.reload
      card_list_2.reload
      card_list_3.reload

      _(card_list_1.default).must_equal(false)
      _(card_list_2.default).must_equal(true)
      _(card_list_3.default).must_equal(false)
    end
  end

  describe '#normalize_friendly_id' do
    it 'normalizes the name for use as a slug' do
      slug = card_list.normalize_friendly_id('  test- & -test--_%-SLUG!')

      _(slug).must_equal('test-and-test-slug')
    end
  end
end
