# frozen_string_literal: true

require 'test_helper'

class CardSetTest < ActiveSupport::TestCase
  describe 'validations' do
    describe 'name' do
      it 'validates presence of name' do
        card_sete = CardSet.new

        card_sete.validate

        card_sete.errors[:name].must_include("can't be blank")
      end
    end
  end
end
