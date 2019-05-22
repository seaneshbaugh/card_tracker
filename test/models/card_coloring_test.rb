# frozen_string_literal: true

require 'test_helper'

class CardColoringTest < ActiveSupport::TestCase
  let(:card_coloring) { CardColoring.new }

  describe 'associations' do
    it 'belongs to card' do
      card_coloring.must belong_to(:card).inverse_of(:card_colorings)
    end

    it 'belongs to color' do
      card_coloring.must belong_to(:color).with_foreign_key(:color_code).inverse_of(:card_colorings).with_primary_key(:color_code)
    end
  end
end
