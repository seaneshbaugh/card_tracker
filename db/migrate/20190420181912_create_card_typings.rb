# frozen_string_literal: true

class CreateCardTypings < ActiveRecord::Migration[5.2]
  def change
    create_table :card_typings do |t|
      t.integer :card_id, null: false
      t.string :card_type_code, null: false
      t.timestamps
    end

    change_table :card_typings do |t|
      t.index %i[card_id card_type_code]
      t.index %i[card_type_code card_id]
    end

    add_foreign_key :card_typings, :cards
    add_foreign_key :card_typings, :card_types, column: :card_type_code, primary_key: :card_type_code
  end
end
