# frozen_string_literal: true

class CardBlock < ApplicationRecord
  belongs_to :card_block_type

  has_many :card_sets, -> { order(release_date: :asc) }, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :card_block_type_id, presence: true

  after_initialize :set_default_attribute_values, if: :new_record?

  private

  def set_default_attribute_values
    self.name ||= ''
  end
end
