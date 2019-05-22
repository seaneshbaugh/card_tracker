# frozen_string_literal: true

class AddSideToCardPart < ActiveRecord::Migration[5.2]
  def change
    change_table :card_parts do |t|
      t.string :side, null: false
      t.index :side
    end
  end
end
