# frozen_string_literal: true

class ChangeCardRarityToRarityCode < ActiveRecord::Migration[5.2]
  def change
    rename_column :cards, :rarity, :rarity_code
  end
end
