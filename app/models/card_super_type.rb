# frozen_string_literal: true

class CardSuperType < ApplicationRecord
  has_many :card_super_typings, dependent: :restrict_with_exception
  has_many :cards, through: :card_super_typings

  validates :card_super_type_code, presence: true
  validates :name, presence: true
end
