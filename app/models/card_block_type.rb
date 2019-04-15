# frozen_string_literal: true

class CardBlockType < ApplicationRecord
  has_many :card_blocks, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true

  after_initialize :set_default_attribute_values, if: :new_record?

  private

  def set_default_attribute_values
    self.name ||= ''
  end
end
