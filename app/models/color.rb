# frozen_string_literal: true

class Color < ApplicationRecord
  has_many :card_colorings, dependent: :restrict_with_exception
  has_many :cards, through: :card_colorings

  validates :color_code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
