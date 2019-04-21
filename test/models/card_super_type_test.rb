require 'test_helper'

class CardSuperTypeTest < ActiveSupport::TestCase
  describe 'validations' do
    describe 'card_super_type_code' do
      it 'validates presence of card_super_type_code' do
        card_super_type = CardSuperType.new

        card_super_type.validate

        card_super_type.errors[:card_super_type_code].must_include("can't be blank")
      end
    end

    describe 'name' do
      it 'validates presence of name' do
        card_super_type = CardSuperType.new

        card_super_type.validate

        card_super_type.errors[:name].must_include("can't be blank")
      end
    end
  end
end
