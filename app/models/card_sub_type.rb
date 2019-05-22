# frozen_string_literal: true

class CardSubType < ApplicationRecord
  has_many :card_sub_typings, dependent: :restrict_with_exception, inverse_of: :card_sub_type
  has_many :card_part_sub_typings, dependent: :restrict_with_exception, inverse_of: :card_sub_type
  has_many :cards, through: :card_sub_typings, inverse_of: :card_sub_types
  has_many :card_parts, through: :card_part_typings, inverse_of: :card_sub_types

  validates :card_sub_type_code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
