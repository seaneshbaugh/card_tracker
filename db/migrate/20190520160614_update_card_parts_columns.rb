# frozen_string_literal: true

class UpdateCardPartsColumns < ActiveRecord::Migration[5.2]
  def change
    remove_index :card_parts, :layout
    remove_index :card_parts, :colors
    remove_index :card_parts, :rarity
    remove_index :card_parts, column: :card_supertypes, type: :fulltext
    remove_index :card_parts, column: :card_types, type: :fulltext
    remove_index :card_parts, column: :card_subtypes, type: :fulltext

    remove_column :card_parts, :layout, :string, default: '', null: false
    remove_column :card_parts, :colors, :string, default: '', null: false
    remove_column :card_parts, :rarity, :string, default: '', null: false
    remove_column :card_parts, :card_supertypes, :string, after: :card_type, null: false, default: ''
    remove_column :card_parts, :card_types, :string, after: :card_supertypes, null: false, default: ''
    remove_column :card_parts, :card_subtypes, :string, after: :card_types, null: false, default: ''

    rename_column :card_parts, :card_type, :type_text

    change_column_default :card_parts, :multiverse_id, from: '', to: nil
    change_column_default :card_parts, :name, from: '', to: nil
    change_column_default :card_parts, :mana_cost, from: '', to: nil
    change_column_default :card_parts, :converted_mana_cost, from: '', to: nil
    change_column_default :card_parts, :type_text, from: '', to: nil
    change_column_default :card_parts, :power, from: '', to: nil
    change_column_default :card_parts, :toughness, from: '', to: nil
    change_column_default :card_parts, :loyalty, from: '', to: nil
    change_column_default :card_parts, :card_number, from: '', to: nil
    change_column_default :card_parts, :artist, from: '', to: nil

    change_column_null :card_parts, :multiverse_id, true
    change_column_null :card_parts, :mana_cost, true
    change_column_null :card_parts, :converted_mana_cost, true
    change_column_null :card_parts, :card_text, true
    change_column_null :card_parts, :flavor_text, true
    change_column_null :card_parts, :power, true
    change_column_null :card_parts, :toughness, true
    change_column_null :card_parts, :loyalty, true

    add_foreign_key :card_parts, :cards

    add_column :card_parts, :original_card_text, :string
    add_column :card_parts, :original_type_text, :string
  end
end
