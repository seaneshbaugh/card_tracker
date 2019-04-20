# frozen_string_literal: true

class AddForeignKeyConstraintOnCardsForRarity < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :cards, :rarities, column: :rarity_code, primary_key: :rarity_code
  end
end
