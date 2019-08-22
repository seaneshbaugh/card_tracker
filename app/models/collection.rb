# frozen_string_literal: true

class Collection < ApplicationRecord
  belongs_to :card, inverse_of: :collections
  belongs_to :user, inverse_of: :collections
  belongs_to :card_list, inverse_of: :collections

  scope :display_order, -> do
    includes(card: { card_set: %i[card_block card_set_type] })
      .merge(CardSet.display_order)
      .merge(Card.display_order)
      .references(:card, :card_blocks, :card_sets, :card_set_types)
  end

  scope :quantity_greater_than_zero, -> { where(Collection.arel_table[:quantity].gt(0)) }

  validates :quantity, numericality: true, presence: true
  validate :card_is_addible?

  after_initialize :set_default_attribute_values, if: :new_record?

  def cards?
    quantity.positive?
  end

  def quantity=(new_quantity)
    new_quantity = new_quantity.clamp(0, 2_147_483_647) if new_quantity.is_a?(Integer)

    super(new_quantity)
  end

  private

  def card_is_addible?
    return if card.nil? || card.addible?

    errors.add(:card, :cannot_be_added_to_collection)
  end

  def set_default_attribute_values
    self.quantity ||= 0
  end
end
