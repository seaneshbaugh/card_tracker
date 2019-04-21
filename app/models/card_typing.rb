# frozen_string_literal: true

class CardTyping < ApplicationRecord
  belongs_to :card, inverse_of: :card_typings
  belongs_to :card_type, foreign_key: :card_type_code, inverse_of: :card_typings, primary_key: :card_type_code
end
