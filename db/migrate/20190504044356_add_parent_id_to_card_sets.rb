# frozen_string_literal: true

class AddParentIdToCardSets < ActiveRecord::Migration[5.2]
  def change
    add_reference :card_sets, :parent, foreign_key: { to_table: :card_sets }
  end
end
