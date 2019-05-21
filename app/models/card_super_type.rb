# frozen_string_literal: true

class CardSuperType < ApplicationRecord
  has_many :card_super_typings, dependent: :restrict_with_exception, inverse_of: :card_super_type
  has_many :card_part_super_typings, dependent: :restrict_with_exception, inverse_of: :card_super_type
  has_many :cards, through: :card_super_typings, inverse_of: :card_super_types
  has_many :card_parts, through: :card_part_super_typings, inverse_of: :card_super_types

  validates :card_super_type_code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
