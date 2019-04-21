# frozen_string_literal: true

class ChangeCardsCardTypeToTypeText < ActiveRecord::Migration[5.2]
  def change
    rename_column :cards, :card_type, :type_text
  end
end
