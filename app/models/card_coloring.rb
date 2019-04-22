# frozen_string_literal: true

class CardColoring < ApplicationRecord
  belongs_to :card, inverse_of: :card_colorings
  belongs_to :color, foreign_key: :color_code, inverse_of: :card_colorings, primary_key: :color_code
end
