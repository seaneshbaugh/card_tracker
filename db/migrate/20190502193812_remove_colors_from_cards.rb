# frozen_string_literal: true

class RemoveColorsFromCards < ActiveRecord::Migration[5.2]
  def change
    remove_index :cards, :colors
    remove_column :cards, :colors, :string, null: false, default: ''
  end
end
