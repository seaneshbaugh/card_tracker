# frozen_string_literal: true

class CardType < ApplicationRecord
  has_many :card_typings, dependent: :restrict_with_exception
  has_many :cards, through: :card_typings

  validates :card_type_code, presence: true
  validates :name, presence: true
end
