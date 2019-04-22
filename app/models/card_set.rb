# frozen_string_literal: true

class CardSet < ApplicationRecord
  belongs_to :card_set_type
  belongs_to :card_block, optional: true
  has_many :cards, dependent: :restrict_with_exception, inverse_of: :card_set

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :code
end
