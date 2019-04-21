# frozen_string_literal: true

# TODO: Rename this to CardSetType. It makes more sense to group sets by a set
# type and then, within that group them by block if they have a block. Some sets
# do not have a block. Blocks have an inferred type through the sets that make
# them up. However if sets are grouped by set type then keeping track of block
# type doesn't get you anything. This will also mean that blocks need to be made
# an optional association of sets.
# This may make sorting in a sensical way difficult depending on the interface.
class CardBlockType < ApplicationRecord
  has_many :card_blocks, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true

  after_initialize :set_default_attribute_values, if: :new_record?

  private

  def set_default_attribute_values
    self.name ||= ''
  end
end
