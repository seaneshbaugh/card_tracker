# frozen_string_literal: true

class CardSetType < ApplicationRecord
  has_many :card_set, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
end
