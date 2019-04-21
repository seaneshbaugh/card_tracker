# frozen_string_literal: true

class CreateCardSubTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :card_sub_types, id: :string, primary_key: :card_sub_type_code do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
