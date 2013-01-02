class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :multiverse_id,       :null => false, :default => ''
      t.string :name,                :null => false, :default => ''
      t.integer :card_set_id
      t.string :mana_cost,           :null => false, :default => ''
      t.string :converted_mana_cost, :null => false, :default => ''
      t.string :card_type,           :null => false, :default => ''
      t.text :card_text,             :null => false, :default => ''
      t.text :flavor_text,           :null => false, :default => ''
      t.string :power,               :null => false, :default => ''
      t.string :toughness,           :null => false, :default => ''
      t.string :loyalty,             :null => false, :default => ''
      t.string :rarity,              :null => false, :default => ''
      t.string :card_number,         :null => false, :default => ''
      t.string :artist,              :null => false, :default => ''
      t.timestamps
    end

    change_table :cards do |t|
      t.index :multiverse_id
      t.index :name
      t.index :card_set_id
      t.index :mana_cost
      t.index :converted_mana_cost
      t.index :card_type
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
