class CardSetsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @card_list = CardList.where('`card_lists`.`user_id` = ? AND `card_lists`.`slug` = ?', current_user.id, params[:list_id]).first

    if @card_list.nil?
      flash[:error] = t('messages.card_lists.could_not_find')

      redirect_to root_url and return
    end

    @card_sets = CardSet.includes(:card_block => :card_block_type).order('`card_block_types`.`id`, `card_blocks`.`id`, `card_sets`.`release_date` ASC')
  end
end
