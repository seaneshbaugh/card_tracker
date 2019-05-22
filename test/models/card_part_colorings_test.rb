# frozen_string_literal: true

require 'test_helper'

class CardPartColoringTest < ActiveSupport::TestCase
  let(:card_part_coloring) { CardPartColoring.new }

  describe 'associations' do
    it 'belongs to card_part' do
      card_part_coloring.must belong_to(:card_part).inverse_of(:card_part_colorings)
    end

    it 'belongs to color' do
      card_part_coloring.must belong_to(:color).with_foreign_key(:color_code).inverse_of(:card_part_colorings).with_primary_key(:color_code)
    end
  end
end
