# frozen_string_literal: true

class AddColorsToCards < ActiveRecord::Migration[4.2]
  def change
    add_column :cards, :colors, :string, after: :converted_mana_cost, null: false, default: ''
    add_index :cards, :colors, type: :fulltext
  end
end
