# frozen_string_literal: true

class RecreateCardSetTypes < ActiveRecord::Migration[5.2]
  def change
    remove_reference :card_sets, :card_set_type, foreign_key: true, null: false

    drop_table :card_set_types, force: :cascade do |t|
      t.string :name, default: '', null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index %i[created_at], name: 'index_card_set_types_on_created_at'
      t.index %i[name], name: 'index_card_set_types_on_name'
      t.index %i[updated_at], name: 'index_card_set_types_on_updated_at'
    end

    create_table :card_set_types, id: :string, primary_key: :card_set_type_code do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_column :card_sets, :card_set_type_code, :string, null: false
    add_index :card_sets, :card_set_type_code
    add_foreign_key :card_sets, :card_set_types, column: :card_set_type_code, primary_key: :card_set_type_code
  end
end
