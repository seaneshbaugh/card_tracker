# frozen_string_literal: true

class AddScyrfallIdToCards < ActiveRecord::Migration[5.2]
  def change
    change_table :cards do |t|
      t.string :scryfall_id
    end
  end
end
