# frozen_string_literal: true

class Collection < ApplicationRecord
  belongs_to :card
  belongs_to :user
  belongs_to :card_list

  validates :card_id, presence: true
  validates :user_id, presence: true
  validates :card_list_id, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2_147_483_647 }, presence: true

  after_initialize :set_default_attribute_values, if: :new_record?

  private

  def set_default_attribute_values
    self.quantity ||= 0
  end
end
