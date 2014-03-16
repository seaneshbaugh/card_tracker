class AddShowCardNumbersToCardSets < ActiveRecord::Migration
  def change
    add_column :card_sets, :show_card_numbers, :boolean, :after => :prerelease_date, :null => false, :default => true
    add_index :card_sets, :show_card_numbers
  end
end
