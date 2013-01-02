class CreateCardSets < ActiveRecord::Migration
  def change
    create_table :card_sets do |t|
      t.string :name,          :null => false, :default => ''
      t.integer :card_block_id
      t.string :code,          :null => false, :default => ''
      t.date :release_date
      t.date :prerelease_date
      t.timestamps
    end

    change_table :card_sets do |t|
      t.index :name
      t.index :code
      t.index :release_date
      t.index :prerelease_date
      t.index :created_at
      t.index :updated_at
    end
  end
end
