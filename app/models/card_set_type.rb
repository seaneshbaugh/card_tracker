# frozen_string_literal: true

class CardSetType < ApplicationRecord
  has_many :card_sets, dependent: :restrict_with_exception, foreign_key: :card_set_type_code, inverse_of: :card_set_type

  scope :display_order, -> { order(order: :asc) }

  validates :name, presence: true, uniqueness: true
  validates :order, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2_147_483_647 }, presence: true
end
