class CardsController < ApplicationController
  before_filter :authenticate_user!

  def index
    if params[:set_id].to_i.to_s == params[:set_id]
      @card_set = CardSet.where(:id => params[:set_id]).first
    else
      @card_set = CardSet.where(:slug => params[:set_id]).first
    end

    if @card_set.nil?
      flash[:error] = t('messages.card_sets.could_not_find')

      redirect_to sets_url and return
    end

    @search = Card.search(params[:q])

    @cards = @search.result.includes(:card_set, :card_parts, :collections).where(:card_set_id => @card_set.id).order('cast(`cards`.`card_number` as unsigned) ASC, `cards`.`id` ASC')
  end

  def show
    if params[:set_id].to_i.to_s == params[:set_id]
      @card_set = CardSet.where(:id => params[:set_id]).first
    else
      @card_set = CardSet.where(:slug => params[:set_id]).first
    end

    if @card_set.nil?
      flash[:error] = t('messages.card_sets.could_not_find')

      redirect_to sets_url and return
    end

    @card = Card.includes(:collections).where(:id => params[:id]).first

    @collection = @card.collection_for(current_user)

    if @card.nil?
      flash[:error] = t('messages.cards.could_not_find')

      redirect_to set_cards_url(@card_set)
    end
  end

  def search
    @search = Card.search(params[:q])

    @cards = @search.result.includes(:collections, :card_set => { :card_block => :card_block_type }).order('`card_block_types`.`id`, `card_blocks`.`id`, `card_sets`.`release_date` ASC, cast(`cards`.`card_number` as unsigned) ASC, `cards`.`name` ASC').page(params[:page]).per(200)

    @sets = @cards.group_by { |card| card.card_set }.sort_by { |card_set, _| card_set.release_date }
  end
end
