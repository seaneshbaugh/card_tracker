require 'test_helper'

class CardTypeTest < ActiveSupport::TestCase
  let(:card_type) { CardType.new }

  describe 'associations' do
    it 'has many card_typings' do
      _(card_type).must(have_many(:card_typings).dependent(:restrict_with_exception).with_foreign_key(:card_type_code).inverse_of(:card_type))
    end

    it 'has many card_part_typings' do
      _(card_type).must(have_many(:card_part_typings).dependent(:restrict_with_exception).with_foreign_key(:card_type_code).inverse_of(:card_type))
    end

    it 'has many cards through card_typings' do
      _(card_type).must(have_many(:cards).through(:card_typings))
    end
  end

  describe 'validations' do
    describe 'card_type_code' do
      it 'validates presence of card_type_code' do
        _(card_type).must(validate_presence_of(:card_type_code))
      end

      it 'validates uniqueness of card_type_code' do
        _(card_type).must(validate_uniqueness_of(:card_type_code))
      end
    end

    describe 'name' do
      it 'validates presence of name' do
        _(card_type).must(validate_presence_of(:name))
      end

      it 'validates uniqueness of name' do
        _(card_type).must(validate_uniqueness_of(:name))
      end
    end
  end
end
