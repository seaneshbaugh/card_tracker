require 'test_helper'

class CardTypeTest < ActiveSupport::TestCase
  describe 'validations' do
    describe 'card_type_code' do
      it 'validates presence of card_type_code' do
        card_type = CardType.new

        card_type.validate

        card_type.errors[:card_type_code].must_include("can't be blank")
      end
    end

    describe 'name' do
      it 'validates presence of name' do
        card_type = CardType.new

        card_type.validate

        card_type.errors[:name].must_include("can't be blank")
      end
    end
  end
end
