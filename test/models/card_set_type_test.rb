# frozen_string_literal: true

require 'test_helper'

class CardSetTypeTest < ActiveSupport::TestCase
  describe 'validations' do
    describe 'name' do
      it 'validates presence of name' do
        card_set_type = CardSetType.new

        card_set_type.validate

        card_set_type.errors[:name].must_include("can't be blank")
      end
    end
  end
end
