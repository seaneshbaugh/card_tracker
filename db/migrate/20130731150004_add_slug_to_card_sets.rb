class AddSlugToCardSets < ActiveRecord::Migration
  def change
    add_column :card_sets, :slug, :string, :after => :name, :null => false, :default => ''
    add_index :card_sets, :slug
  end
end
