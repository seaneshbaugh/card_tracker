# frozen_string_literal: true

class AddForeignKeyConstraintOnCardsForLayout < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :cards, :layouts, column: :layout_code, primary_key: :layout_code
  end
end
