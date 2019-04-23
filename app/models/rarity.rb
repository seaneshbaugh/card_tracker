# frozen_string_literal: true

class Rarity < ApplicationRecord
  has_many :cards, dependent: :restrict_with_exception, foreign_key: :rarity_code, inverse_of: :rarity

  validates :rarity_code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
