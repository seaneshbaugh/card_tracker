# frozen_string_literal: true

class CreateCardBlockTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :card_block_types do |t|
      t.string :name, null: false, default: ''
      t.timestamps
    end

    change_table :card_block_types do |t|
      t.index :name
      t.index :created_at
      t.index :updated_at
    end
  end
end
