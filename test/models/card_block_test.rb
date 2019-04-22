# frozen_string_literal: true

require 'test_helper'

class CardBlockTest < ActiveSupport::TestCase
  describe 'validations' do
    describe 'name' do
      it 'validates presence of name' do
        card_blocke = CardBlock.new

        card_blocke.validate

        card_blocke.errors[:name].must_include("can't be blank")
      end
    end
  end
end
