# frozen_string_literal: true

class CreateCardTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :card_types, id: :string, primary_key: :card_type_code do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
