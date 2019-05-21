# frozen_string_literal: true

class CardType < ApplicationRecord
  has_many :card_typings, dependent: :restrict_with_exception, foreign_key: :card_type_code, inverse_of: :card_type
  has_many :card_part_typings, dependent: :restrict_with_exception, foreign_key: :card_type_code, inverse_of: :card_type
  has_many :cards, through: :card_typings, inverse_of: :card_types
  has_many :card_parts, through: :card_part_typings, inverse_of: :card_types

  validates :card_type_code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
