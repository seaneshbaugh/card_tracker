class CardsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @card_set = CardSet.includes(:cards => :collections).where(:id => params[:set_id]).order('cast(cards.card_number as unsigned) ASC').first

    if @card_set.nil?
      flash[:error] = t('messages.card_sets.could_not_find')

      redirect_to sets_url
    end
  end

  def show
    @card_set = CardSet.includes(:cards).where(:id => params[:set_id]).first

    if @card_set.nil?
      flash[:error] = t('messages.card_sets.could_not_find')

      redirect_to sets_url
    end

    @card = Card.where(:id => params[:id]).first

    if @card.nil?
      flash[:error] = t('messages.cards.could_not_find')

      redirect_to set_cards_url(@card_set)
    end
  end
end
