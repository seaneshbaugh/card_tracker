# frozen_string_literal: true

class Color < ApplicationRecord
  has_many :card_colorings, dependent: :restrict_with_exception, foreign_key: :color_code, inverse_of: :color
  has_many :card_part_colorings, dependent: :restrict_with_exception, foreign_key: :color_code, inverse_of: :color
  has_many :cards, through: :card_colorings, inverse_of: :colors
  has_many :card_parts, through: :card_part_colorings, inverse_of: :colors

  validates :color_code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
