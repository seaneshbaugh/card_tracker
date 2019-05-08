# frozen_string_literal: true

class CardSet < ApplicationRecord
  extend FriendlyId

  belongs_to :card_set_type, foreign_key: :card_set_type_code, inverse_of: :card_sets, primary_key: :card_set_type_code
  belongs_to :card_block, inverse_of: :card_sets, optional: true
  belongs_to :parent, class_name: 'CardSet', inverse_of: :children, optional: true
  has_many :cards, dependent: :restrict_with_exception, inverse_of: :card_set
  has_many :children, class_name: 'CardSet', dependent: :restrict_with_exception, inverse_of: :parent

  scope :display_order, -> do
    includes(:card_set_type, :card_block)
      .merge(CardSetType.display_order)
      .merge(CardBlock.display_order)
      .order(release_date: :asc)
      .references(:card_set_type, :card_block)
  end

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
  validates :keyrune_code, presence: true

  friendly_id :code, use: :slugged
end
