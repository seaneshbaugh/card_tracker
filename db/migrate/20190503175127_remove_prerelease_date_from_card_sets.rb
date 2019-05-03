# frozen_string_literal: true

class RemovePrereleaseDateFromCardSets < ActiveRecord::Migration[5.2]
  def change
    remove_index :card_sets, :prerelease_date
    remove_column :card_sets, :prerelease_date, :date
  end
end
