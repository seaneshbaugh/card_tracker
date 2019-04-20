# frozen_string_literal: true

require 'test_helper'

class RarityTest < ActiveSupport::TestCase
  describe 'validations' do
    describe 'rarity_code' do
      it 'validates presence of rarity_code' do
        rarity = Rarity.new

        rarity.validate

        rarity.errors[:name].must_include("can't be blank")
      end
    end

    describe 'name' do
      it 'validates presence of name' do
        rarity = Rarity.new

        rarity.validate

        rarity.errors[:name].must_include("can't be blank")
      end
    end
  end
end
