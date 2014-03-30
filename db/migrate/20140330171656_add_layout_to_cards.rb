class AddLayoutToCards < ActiveRecord::Migration
  def change
    add_column :cards, :layout, :string, :after => :card_set_id, :null => false, :default => ''
    add_index :cards, :layout
  end
end
