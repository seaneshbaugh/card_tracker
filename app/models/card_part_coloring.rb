# frozen_string_literal: true

class CardPartColoring < ApplicationRecord
  belongs_to :card_part, inverse_of: :card_part_colorings
  belongs_to :color, foreign_key: :color_code, inverse_of: :card_part_colorings, primary_key: :color_code
end
