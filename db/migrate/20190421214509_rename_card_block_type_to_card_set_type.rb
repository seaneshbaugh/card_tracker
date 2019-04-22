# frozen_string_literal: true

class RenameCardBlockTypeToCardSetType < ActiveRecord::Migration[5.2]
  def change
    remove_index :card_blocks, :card_block_type_id
    remove_column :card_blocks, :card_block_type_id, :integer
    rename_table :card_block_types, :card_set_types
    add_reference :card_sets, :card_set_type, foreign_key: true, null: false
  end
end
