# frozen_string_literal: true

class Collection < ApplicationRecord
  belongs_to :card, inverse_of: :collections
  belongs_to :user, inverse_of: :collections
  belongs_to :card_list, inverse_of: :collections

  validates :quantity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2_147_483_647 }, presence: true

  after_initialize :set_default_attribute_values, if: :new_record?

  def cards?
    quantity.positive?
  end

  private

  def set_default_attribute_values
    self.quantity ||= 0
  end
end
