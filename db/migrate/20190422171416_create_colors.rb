# frozen_string_literal: true

class CreateColors < ActiveRecord::Migration[5.2]
  def change
    create_table :colors, id: :string, primary_key: :color_code do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
