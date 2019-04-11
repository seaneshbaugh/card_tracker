# frozen_string_literal: true

class AddSlugToCardSets < ActiveRecord::Migration[4.2]
  def change
    add_column :card_sets, :slug, :string, after: :name, null: false, default: ''
    add_index :card_sets, :slug
  end
end
