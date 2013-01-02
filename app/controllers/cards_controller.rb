class CardsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @card_set = CardSet.includes(:cards).where(:id => params[:set_id]).first

    if @card_set.nil?
      flash[:error] = t('messages.card_sets.could_not_find')

      redirect_to card_sets_url
    end
  end

  def show
    @card_set = CardSet.includes(:cards).where(:id => params[:set_id]).first

    if @card_set.nil?
      flash[:error] = t('messages.card_sets.could_not_find')

      redirect_to card_sets_url
    end

    @card = Card.where(:id => params[:id]).first
  end
end
