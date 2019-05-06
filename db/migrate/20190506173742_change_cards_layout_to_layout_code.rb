# frozen_string_literal: true

class ChangeCardsLayoutToLayoutCode < ActiveRecord::Migration[5.2]
  def change
    rename_column :cards, :layout, :layout_code
  end
end
