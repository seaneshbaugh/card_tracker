class CardSetsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @card_sets = CardSet.includes(:card_block => :card_block_type).order('card_block_types.id, card_blocks.id, card_sets.release_date ASC')
  end

  def show
    @card_set = CardSet.where(:id => params[:id]).first

    if @card_set.nil?
      flash[:error] = t('messages.card_sets.could_not_find')

      redirect_to card_sets_url
    end
  end
end
