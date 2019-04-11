# frozen_string_literal: true

class CreateCardParts < ActiveRecord::Migration[4.2]
  def change
    create_table :card_parts do |t|
      t.string :multiverse_id,       null: false, default: ''
      t.string :name,                null: false, default: ''
      t.integer :card_id
      t.string :layout,              null: false, default: ''
      t.string :mana_cost,           null: false, default: ''
      t.string :converted_mana_cost, null: false, default: ''
      t.string :colors,              null: false, default: ''
      t.string :card_type,           null: false, default: ''
      t.string :card_supertypes,     null: false, default: ''
      t.string :card_types,          null: false, default: ''
      t.string :card_subtypes,       null: false, default: ''
      t.text :card_text,             null: false
      t.text :flavor_text,           null: false
      t.string :power,               null: false, default: ''
      t.string :toughness,           null: false, default: ''
      t.string :loyalty,             null: false, default: ''
      t.string :rarity,              null: false, default: ''
      t.string :card_number,         null: false, default: ''
      t.string :artist,              null: false, default: ''
      t.timestamps
    end

    change_table :card_parts do |t|
      t.index :multiverse_id
      t.index :name
      t.index :card_id
      t.index :layout
      t.index :mana_cost
      t.index :converted_mana_cost
      t.index :colors, type: :fulltext
      t.index :card_type
      t.index :card_supertypes, type: :fulltext
      t.index :card_types, type: :fulltext
      t.index :card_subtypes, type: :fulltext
      t.index :power
      t.index :toughness
      t.index :loyalty
      t.index :rarity
      t.index :card_number
      t.index :artist
      t.index :created_at
      t.index :updated_at
    end
  end
end
