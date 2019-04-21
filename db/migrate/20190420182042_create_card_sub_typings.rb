# frozen_string_literal: true

class CreateCardSubTypings < ActiveRecord::Migration[5.2]
  def change
    create_table :card_sub_typings do |t|
      t.integer :card_id, null: false
      t.string :card_sub_type_code, null: false
      t.timestamps
    end

    change_table :card_sub_typings do |t|
      t.index %i[card_id card_sub_type_code]
      t.index %i[card_sub_type_code card_id]
    end

    add_foreign_key :card_sub_typings, :cards
    add_foreign_key :card_sub_typings, :card_sub_types, column: :card_sub_type_code, primary_key: :card_sub_type_code
  end
end
