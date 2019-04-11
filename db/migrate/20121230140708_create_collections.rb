# frozen_string_literal: true

class CreateCollections < ActiveRecord::Migration[4.2]
  def change
    create_table :collections do |t|
      t.integer :card_id,  null: false
      t.integer :user_id,  null: false
      t.integer :quantity, null: false, default: ''
      t.timestamps
    end

    change_table :collections do |t|
      t.index :card_id
      t.index :user_id
      t.index :quantity
      t.index :created_at
      t.index :updated_at
    end
  end
end
