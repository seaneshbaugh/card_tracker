class CreateCardLists < ActiveRecord::Migration
  def change
    create_table :card_lists do |t|
      t.integer :user_id,  :null => false
      t.string :name, :null => false, :default => ''
      t.string :slug, :null => false, :default => ''
      t.boolean :have, :null => false, :default => true
      t.integer :order, :null => false, :default => 0
      t.boolean :default, :null => false, :default => false
      t.timestamps
    end

    change_table :card_lists do |t|
      t.index :user_id
      t.index :name
      t.index :slug
      t.index :have
      t.index :order
      t.index :default
      t.index :created_at
      t.index :updated_at
    end
  end
end
