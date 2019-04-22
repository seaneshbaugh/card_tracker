# frozen_string_literal: true

class CardPart < ApplicationRecord
  belongs_to :card

  delegate :card_set, to: :card, allow_nil: true

  validates :multiverse_id, presence: true
  validates :name, presence: true
end
