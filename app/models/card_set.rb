# frozen_string_literal: true

class CardSet < ApplicationRecord
  extend FriendlyId

  belongs_to :card_set_type, foreign_key: :card_set_type_code, inverse_of: :card_sets, primary_key: :card_set_type_code
  belongs_to :card_block, inverse_of: :card_sets, optional: true
  has_many :cards, dependent: :restrict_with_exception, inverse_of: :card_set

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :code
end
