class CardSetsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @card_sets = CardSet.includes(:card_block => :card_block_type).order('`card_block_types`.`id`, `card_blocks`.`id`, `card_sets`.`release_date` ASC')
  end
end
