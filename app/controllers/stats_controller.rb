class StatsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @total_cards_in_collections = Collection.where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0', current_user.id).sum(:quantity)

    @unique_cards_in_collections = Collection.where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0', current_user.id).count

    @card_blocks = CardBlock.includes(:card_sets)

    @card_sets = @card_blocks.map { |card_block| card_block.card_sets }.flatten

    #@collections = Collection.includes(:card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0', current_user.id).order('`collections`.`quantity` ASC')

    %w(White Blue Black Red Green).each do |color|
      instance_variable_set "@number_of_#{color.downcase}", Collection.joins(:card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `cards`.`colors` = ?', current_user.id, color).sum(:quantity)
    end

    @number_of_multi = Collection.joins(:card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `cards`.`colors` LIKE "%;%"', current_user.id).sum(:quantity)

    @number_of_colorless = Collection.joins(:card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `cards`.`colors` = ""', current_user.id).sum(:quantity)

    @number_of_land = Collection.joins(:card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `cards`.`card_types` LIKE "%Land%"', current_user.id).sum(:quantity)
  end
end
