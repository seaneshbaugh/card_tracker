require 'benchmark'

class StatsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @card_blocks = CardBlock.includes(:card_sets => :cards)

    @card_sets = @card_blocks.map { |card_block| card_block.card_sets }.flatten

    @collections = Collection.includes(:card => :card_set).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0', current_user.id).order('`collections`.`quantity` ASC')

    @total_cards_in_collections = @collections.map { |collection| collection.quantity }.inject(:+)

    @unique_cards_in_collections = @collections.length

    ['white', 'blue', 'black', 'red', 'green', 'colorless', 'multi', 'land'].each do |color|
      instance_variable_set "@#{color}_collections", @collections.select { |collection| collection.card.send("is_#{color}?") }
    end
  end
end
