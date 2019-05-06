# frozen_string_literal: true

class CreateLayouts < ActiveRecord::Migration[5.2]
  def change
    create_table :layouts, id: :string, primary_key: :layout_code do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
