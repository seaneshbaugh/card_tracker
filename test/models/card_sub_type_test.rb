# frozen_string_literal: true

require 'test_helper'

class CardSubTypeTest < ActiveSupport::TestCase
  describe 'validations' do
    describe 'card_sub_type_code' do
      it 'validates presence of card_sub_type_code' do
        card_sub_type = CardSubType.new

        card_sub_type.validate

        card_sub_type.errors[:card_sub_type_code].must_include("can't be blank")
      end
    end

    describe 'name' do
      it 'validates presence of name' do
        card_sub_type = CardSubType.new

        card_sub_type.validate

        card_sub_type.errors[:name].must_include("can't be blank")
      end
    end
  end
end
