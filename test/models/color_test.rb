# frozen_string_literal: true

require 'test_helper'

class ColorTest < ActiveSupport::TestCase
  let(:color) { Color.new }

  describe 'associations' do
    it 'has many card_colorings' do
      _(color).must(have_many(:card_colorings).dependent(:restrict_with_exception).with_foreign_key(:color_code).inverse_of(:color))
    end

    it 'has many card_part_colorings' do
      _(color).must(have_many(:card_part_colorings).dependent(:restrict_with_exception).with_foreign_key(:color_code).inverse_of(:color))
    end

    it 'has many cards through card_colorings' do
      _(color).must(have_many(:cards).through(:card_colorings).inverse_of(:colors))
    end

    it 'has many cards_parts through card_part_colorings' do
      _(color).must(have_many(:card_parts).through(:card_part_colorings).inverse_of(:colors))
    end
  end

  describe 'validations' do
    describe 'color_code' do
      it 'validates presence of color_code' do
        _(color).must(validate_presence_of(:color_code))
      end

      it 'validates uniqueness of color_code' do
        _(color).must(validate_uniqueness_of(:color_code))
      end
    end

    describe 'name' do
      it 'validates presence of name' do
        _(color).must(validate_presence_of(:name))
      end

      it 'validates uniqueness of name' do
        _(color).must(validate_uniqueness_of(:name))
      end
    end
  end
end
