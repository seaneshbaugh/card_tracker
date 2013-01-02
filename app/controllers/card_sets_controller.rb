class CardSetsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @card_sets = CardSet.order('release_date ASC')
  end

  def show
    @card_set = CardSet.where(:id => params[:id])

    if @card_set.nil?
      flash[:error] = t('messages.card_sets.could_not_find')

      redirect_to card_sets_url
    end
  end
end
