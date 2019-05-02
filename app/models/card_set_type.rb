# frozen_string_literal: true

class CardSetType < ApplicationRecord
  has_many :card_sets, dependent: :restrict_with_exception, foreign_key: :card_set_type_code, inverse_of: :card_set_type

  validates :name, presence: true, uniqueness: true
end
