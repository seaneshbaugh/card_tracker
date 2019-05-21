# frozen_string_literal: true

class CardPartTyping < ApplicationRecord
  belongs_to :card_part, inverse_of: :card_part_typings
  belongs_to :card_type, foreign_key: :card_type_code, inverse_of: :card_part_typings, primary_key: :card_type_code
end
