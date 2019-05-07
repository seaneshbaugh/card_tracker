# frozen_string_literal: true

class AddOrderToCardSetTypes < ActiveRecord::Migration[5.2]
  def change
    change_table :card_set_types, bulk: true do |t|
      t.integer :order, default: 0, null: false
      t.index :order
    end
  end
end
