# frozen_string_literal: true

class AddHandAndLifeToCards < ActiveRecord::Migration[5.2]
  def change
    change_table :cards, bulk: true do |t|
      t.string :hand
      t.string :life
    end
  end
end
