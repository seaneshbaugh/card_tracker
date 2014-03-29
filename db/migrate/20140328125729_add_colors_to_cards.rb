class AddColorsToCards < ActiveRecord::Migration
  def change
    add_column :cards, :colors, :string, :after => :converted_mana_cost, :null => false, :default => ''
    add_index :cards, :colors, :type => :fulltext
  end
end
