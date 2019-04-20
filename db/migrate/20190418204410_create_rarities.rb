# frozen_string_literal: true

class CreateRarities < ActiveRecord::Migration[5.2]
  def change
    create_table :rarities, id: :string, primary_key: :rarity_code do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
