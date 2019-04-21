# frozen_string_literal: true

class CardSubType < ApplicationRecord
  has_many :card_sub_typings, dependent: :restrict_with_exception
  has_many :cards, through: :card_sub_typings

  validates :card_sub_type_code, presence: true
  validates :name, presence: true
end
