# frozen_string_literal: true

class CardBlock < ApplicationRecord
  has_many :card_sets, -> { order(release_date: :asc) }, dependent: :restrict_with_exception, inverse_of: :card_block

  # TODO: Add release date to CardBlock. It should be based on the release date
  # of the first set in the block.
  scope :display_order, -> { order(id: :asc) }

  validates :name, presence: true, uniqueness: true
end
