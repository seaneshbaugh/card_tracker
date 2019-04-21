# frozen_string_literal: true

class RemoveIndicesFromCards < ActiveRecord::Migration[5.2]
  def change
    remove_index :cards, :type_text
    remove_index :cards, :created_at
    remove_index :cards, :updated_at
  end
end
