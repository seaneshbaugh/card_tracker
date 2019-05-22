# frozen_string_literal: true

class CardPartSubTyping < ApplicationRecord
  belongs_to :card_part, inverse_of: :card_part_sub_typings
  belongs_to :card_sub_type, foreign_key: :card_sub_type_code, inverse_of: :card_part_sub_typings, primary_key: :card_sub_type_code
end
