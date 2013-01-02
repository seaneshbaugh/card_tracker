class CreateCardBlocks < ActiveRecord::Migration
  def change
    create_table :card_blocks do |t|
      t.string :name,               :null => false, :default => ''
      t.integer :card_block_type_id
      t.timestamps
    end

    change_table :card_blocks do |t|
      t.index :name, :unique => true
      t.index :card_block_type_id
      t.index :created_at
      t.index :updated_at
    end
  end
end
