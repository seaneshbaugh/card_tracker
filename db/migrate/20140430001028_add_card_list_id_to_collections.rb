class AddCardListIdToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :card_list_id, :integer, :after => :user_id
    add_index :collections, :card_list_id
  end
end
