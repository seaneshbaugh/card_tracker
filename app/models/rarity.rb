# frozen_string_literal: true

class Rarity < ApplicationRecord
  has_many :cards, dependent: :restrict_with_exception, inverse_of: :rarity

  validates :rarity_code, presence: true
  validates :name, presence: true
end
