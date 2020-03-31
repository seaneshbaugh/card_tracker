require 'test_helper'

class CardSuperTypeTest < ActiveSupport::TestCase
  let(:card_super_type) { CardSuperType.new }

  describe 'validations' do
    describe 'card_super_type_code' do
      it 'validates presence of card_super_type_code' do
        _(card_super_type).must(validate_presence_of(:card_super_type_code))
      end

      it 'validates uniqueness of card_super_type_code' do
        _(card_super_type).must(validate_uniqueness_of(:card_super_type_code))
      end
    end

    describe 'name' do
      it 'validates presence of name' do
        _(card_super_type).must(validate_presence_of(:name))
      end

      it 'vailidates uniqueness of name' do
        _(card_super_type).must(validate_uniqueness_of(:name))
      end
    end
  end
end
