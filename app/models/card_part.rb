# frozen_string_literal: true

class CardPart < ApplicationRecord
  belongs_to :card, inverse_of: :card_parts
  has_many :card_part_colorings, dependent: :restrict_with_exception, inverse_of: :card_part
  has_many :card_part_super_typings, dependent: :restrict_with_exception, inverse_of: :card_part
  has_many :card_part_typings, dependent: :restrict_with_exception, inverse_of: :card_part
  has_many :card_part_sub_typings, dependent: :restrict_with_exception, inverse_of: :card_part
  has_many :colors, through: :card_part_colorings, foreign_key: :color_code, inverse_of: :card_part
  has_many :card_super_types, through: :card_part_super_typings, foreign_key: :card_super_type_code, inverse_of: :card_part
  has_many :card_types, through: :card_part_typings, foreign_key: :card_type_code, inverse_of: :card_part
  has_many :card_sub_types, through: :card_part_sub_typings, foreign_key: :card_sub_type_code, inverse_of: :card_part

  delegate :card_set, to: :card, allow_nil: true

  validates :name, presence: true
end
