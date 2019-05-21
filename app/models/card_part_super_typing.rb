# frozen_string_literal: true

class CardPartSuperTyping < ApplicationRecord
  belongs_to :card_part, inverse_of: :card_part_super_typings
  belongs_to :card_super_type, foreign_key: :card_super_type_code, inverse_of: :card_part_super_typings, primary_key: :card_super_type_code
end
