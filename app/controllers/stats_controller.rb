class StatsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @total_cards_in_collections = Collection.joins(:card_list).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1', current_user.id).sum(:quantity)

    @unique_cards_in_collections = Collection.joins(:card_list).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1', current_user.id).select('distinct `collections`.`card_id`').count

    @card_sets = CardSet.includes(:card_block => :card_block_type).order('`card_block_types`.`id`, `card_blocks`.`id`, `card_sets`.`release_date` ASC')

    @card_set_stats = @card_sets.map do |card_set|
      card_in_set = card_set.cards.count

      unique_cards = Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ?', current_user.id, card_set.id).select('distinct `collections`.`card_id`').count

      total_cards = Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ?', current_user.id, card_set.id).sum(:quantity)

      if card_in_set > 0
        percent_collected = ((unique_cards.to_f / card_in_set.to_f) * 100.0).to_i
      else
        percent_collected = 0
      end

      if unique_cards == card_in_set
        rarity = :rare
      else
        rarity = :common
      end

      { :card_set => card_set, :card_in_set => card_in_set, :unique_cards => unique_cards, :total_cards => total_cards, :percent_collected => percent_collected, :rarity => rarity }
    end

    #@card_blocks = CardBlock.includes(:card_sets)
    #
    #@card_sets = @card_blocks.map { |card_block| card_block.card_sets }.flatten
    #
    ##@collections = Collection.includes(:card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0', current_user.id).order('`collections`.`quantity` ASC')
    #
    #%w(White Blue Black Red Green).each do |color|
    #  instance_variable_set "@number_of_#{color.downcase}", Collection.joins(:card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `cards`.`colors` = ?', current_user.id, color).sum(:quantity)
    #end
    #
    #@number_of_multi = Collection.joins(:card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `cards`.`colors` LIKE "%;%"', current_user.id).sum(:quantity)
    #
    #@number_of_colorless = Collection.joins(:card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `cards`.`colors` = ""', current_user.id).sum(:quantity)
    #
    #@number_of_land = Collection.joins(:card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `cards`.`card_types` LIKE "%Land%"', current_user.id).sum(:quantity)
  end
end
