# frozen_string_literal: true

require 'test_helper'

class RarityTest < ActiveSupport::TestCase
  let(:rarity) { Rarity.new }

  describe 'associations' do
    it 'has many cards' do
      rarity.must have_many(:cards).dependent(:restrict_with_exception).with_foreign_key(:rarity_code).inverse_of(:rarity)
    end
  end

  describe 'validations' do
    describe 'rarity_code' do
      it 'validates presence of rarity_code' do
        rarity.must validate_presence_of(:rarity_code)
      end

      it 'validates uniqueness of rarity_code' do
        rarity.must validate_uniqueness_of(:rarity_code)
      end
    end

    describe 'name' do
      it 'validates presence of name' do
        rarity.must validate_presence_of(:name)
      end

      it 'validates uniqueness of name' do
        rarity.must validate_uniqueness_of(:name)
      end
    end
  end
end
