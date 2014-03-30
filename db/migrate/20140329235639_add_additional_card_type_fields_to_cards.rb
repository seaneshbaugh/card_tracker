class AddAdditionalCardTypeFieldsToCards < ActiveRecord::Migration
  def change
    add_column :cards, :card_supertypes, :string, :after => :card_type, :null => false, :default => ''
    add_column :cards, :card_types, :string, :after => :card_supertypes, :null => false, :default => ''
    add_column :cards, :card_subtypes, :string, :after => :card_types, :null => false, :default => ''
    add_index :cards, :card_supertypes, :type => :fulltext
    add_index :cards, :card_types, :type => :fulltext
    add_index :cards, :card_subtypes, :type => :fulltext
  end
end
