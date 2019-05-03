# frozen_string_literal: true

class RemoveDefaultsFromCardSetsColumns < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:card_sets, :name, from: '', to: nil)
    change_column_default(:card_sets, :slug, from: '', to: nil)
    change_column_default(:card_sets, :code, from: '', to: nil)
  end
end
