# frozen_string_literal: true

class CreateCardPartSuperTypings < ActiveRecord::Migration[5.2]
  def change
    create_table :card_part_super_typings do |t|
      t.integer :card_part_id, null: false
      t.string :card_super_type_code, null: false
      t.timestamps
    end

    change_table :card_part_super_typings do |t|
      t.index %i[card_part_id card_super_type_code], name: 'index_c_p_s_t_on_card_part_id_and_card_super_type_code'
      t.index %i[card_super_type_code card_part_id], name: 'index_c_p_s_t_on_card_super_type_code_and_card_part_id'
    end

    add_foreign_key :card_part_super_typings, :card_parts
    add_foreign_key :card_part_super_typings, :card_super_types, column: :card_super_type_code, primary_key: :card_super_type_code
  end
end
