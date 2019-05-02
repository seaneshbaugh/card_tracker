# frozen_string_literal: true

class AddOriginalCardTextAndOriginalTypeTextToCards < ActiveRecord::Migration[5.2]
  def change
    change_table :cards, bulk: true do |t|
      t.string :original_card_text
      t.string :original_type_text
    end
  end
end
