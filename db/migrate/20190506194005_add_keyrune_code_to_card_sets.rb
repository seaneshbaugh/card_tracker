# frozen_string_literal: true

class AddKeyruneCodeToCardSets < ActiveRecord::Migration[5.2]
  def change
    add_column :card_sets, :keyrune_code, :string, null: false
  end
end
