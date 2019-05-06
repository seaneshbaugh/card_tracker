# frozen_string_literal: true

class RemoveDefaultsAndNullConstraintsFromCards < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:cards, :multiverse_id, from: '', to: nil)
    change_column_default(:cards, :name, from: '', to: nil)
    change_column_default(:cards, :layout, from: '', to: nil)
    change_column_default(:cards, :mana_cost, from: '', to: nil)
    change_column_default(:cards, :converted_mana_cost, from: '', to: nil)
    change_column_default(:cards, :type_text, from: '', to: nil)
    change_column_default(:cards, :power, from: '', to: nil)
    change_column_default(:cards, :toughness, from: '', to: nil)
    change_column_default(:cards, :loyalty, from: '', to: nil)
    change_column_default(:cards, :rarity_code, from: '', to: nil)
    change_column_default(:cards, :card_number, from: '', to: nil)
    change_column_default(:cards, :artist, from: '', to: nil)

    change_column_null(:cards, :multiverse_id, true)
    change_column_null(:cards, :mana_cost, true)
    change_column_null(:cards, :converted_mana_cost, true)
    change_column_null(:cards, :card_text, true)
    change_column_null(:cards, :flavor_text, true)
    change_column_null(:cards, :power, true)
    change_column_null(:cards, :toughness, true)
    change_column_null(:cards, :loyalty, true)
  end
end
