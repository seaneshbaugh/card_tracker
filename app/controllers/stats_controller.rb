class StatsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @total_cards_in_collections = Collection.where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0', current_user.id).sum(:quantity)

    @unique_cards_in_collections = Collection.where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0', current_user.id).count

    @card_blocks = CardBlock.includes(:card_sets)

    @card_sets = @card_blocks.map { |card_block| card_block.card_sets }.flatten

    @collections = Collection.includes(:card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0', current_user.id).order('`collections`.`quantity` ASC')

    %w(white blue black red green colorless multi land).each do |color|
      instance_variable_set "@#{color}_collections", @collections.select { |collection| collection.card.send("is_#{color}?") }
    end
  end
end
