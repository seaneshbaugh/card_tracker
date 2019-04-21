# frozen_string_literal: true

class RemoveShowCardNumbersFromCardSets < ActiveRecord::Migration[5.2]
  def change
    remove_index :card_sets, :show_card_numbers
    remove_column :card_sets, :show_card_numbers, :boolean, after: :prerelease_date, null: false, default: true
  end
end
