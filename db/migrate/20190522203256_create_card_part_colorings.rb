# frozen_string_literal: true

class CreateCardPartColorings < ActiveRecord::Migration[5.2]
  def change
    create_table :card_part_colorings do |t|
      t.integer :card_part_id, null: false
      t.string :color_code, null: false
      t.timestamps
    end

    change_table :card_part_colorings do |t|
      t.index %i[card_part_id color_code]
      t.index %i[color_code card_part_id]
    end

    add_foreign_key :card_part_colorings, :card_parts
    add_foreign_key :card_part_colorings, :colors, column: :color_code, primary_key: :color_code
  end
end
