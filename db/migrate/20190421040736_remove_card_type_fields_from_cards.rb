# frozen_string_literal: true

class RemoveCardTypeFieldsFromCards < ActiveRecord::Migration[5.2]
  def change
    remove_index :cards, column: :card_supertypes, type: :fulltext
    remove_index :cards, column: :card_types, type: :fulltext
    remove_index :cards, column: :card_subtypes, type: :fulltext
    remove_column :cards, :card_supertypes, :string, after: :card_type, null: false, default: ''
    remove_column :cards, :card_types, :string, after: :card_supertypes, null: false, default: ''
    remove_column :cards, :card_subtypes, :string, after: :card_types, null: false, default: ''
  end
end
