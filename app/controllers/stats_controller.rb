class StatsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @total_cards_in_collections = Collection.joins(:card_list).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1', current_user.id).sum(:quantity)

    @unique_cards_in_collections = Collection.joins(:card_list).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1', current_user.id).select('distinct `collections`.`card_id`').count

    @card_sets = CardSet.includes(:card_block => :card_block_type).order('`card_block_types`.`id`, `card_blocks`.`id`, `card_sets`.`release_date` ASC')

    @card_set_stats = @card_sets.map { |card_set| CardSetStat.new(card_set, current_user) }
  end

  def show
    @card_set = CardSet.where(:slug => params[:id]).first

    @card_set_stat = CardSetStat.new(@card_set, current_user)

    @card_set_stat.get_rarity_stats
  end
end
