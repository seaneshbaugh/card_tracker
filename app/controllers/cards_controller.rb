# frozen_string_literal: true

class CardsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:list_id].present?
      @card_list = CardList.where('`card_lists`.`user_id` = ? AND `card_lists`.`slug` = ?', current_user.id, params[:list_id]).first

      if @card_list.nil?
        flash[:error] = t('messages.card_lists.could_not_find')

        redirect_to(root_url) && return
      end
    else
      @card_list = nil
    end

    @card_set = CardSet.where(slug: params[:set_id]).first

    if @card_set.nil?
      flash[:error] = t('messages.card_sets.could_not_find')

      redirect_to(sets_url) && return
    end

    @search = Card.search(params[:q])

    @cards = @search.result.includes(:card_set, :card_parts, :collections).where(card_set_id: @card_set.id).order('cast(`cards`.`card_number` as unsigned) ASC, `cards`.`id` ASC')

    if @card_list.present?
      render 'index_with_card_list'
    else
      render 'index_without_card_list'
    end
  end

  def show
    if params[:list_id].present?
      @card_list = CardList.where('`card_lists`.`user_id` = ? AND `card_lists`.`slug` = ?', current_user.id, params[:list_id]).first

      if @card_list.nil?
        flash[:error] = t('messages.card_lists.could_not_find')

        redirect_to(root_url) && return
      end
    else
      @card_list = nil
    end

    @card_set = CardSet.where(slug: params[:set_id]).first

    if @card_set.nil?
      flash[:error] = t('messages.card_sets.could_not_find')

      redirect_to(sets_url) && return
    end

    @card = Card.includes(:collections).where(id: params[:id]).first

    if @card.nil?
      flash[:error] = t('messages.cards.could_not_find')

      redirect_to set_cards_url(@card_set)
    end

    if @card_list.present?
      @collection = @card.collection_for(current_user, @card_list)

      render 'show_with_card_list'
    else
      render 'show_without_card_list'
    end
  end

  def search
    @search = Card.search(params[:q])

    @cards = @search.result.includes(:collections, card_set: { card_block: :card_block_type }).order('`card_block_types`.`id`, `card_blocks`.`id`, `card_sets`.`release_date` ASC, cast(`cards`.`card_number` as unsigned) ASC, `cards`.`name` ASC').page(params[:page]).per(200)

    @sets = @cards.group_by(&:card_set).sort_by { |card_set, _| card_set.release_date }
  end
end
