# frozen_string_literal: true

class CardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @card_list = find_card_list
    @card_set = find_card_set
    @search = Card.search(params[:q])
    @cards = @search.result.includes(:card_parts, :card_set, :card_types, :collections, :colors).where(card_set_id: @card_set.id).display_order

    if @card_list.present?
      render 'index_with_card_list'
    else
      render 'index_without_card_list'
    end
  end

  def show
    @card_list = find_card_list
    @card_set = find_card_set
    @card = Card.includes(:card_parts, { card_set: :card_block }, :card_sub_types, :card_super_types, :card_types, :collections, :colors).find_by!(id: params[:id])

    if @card_list.present?
      @collection = @card.collection_for(current_user, @card_list)

      render 'show_with_card_list'
    else
      render 'show_without_card_list'
    end
  end

  def search
    @search = Card.search(params[:q])
    @cards = @search.result.includes(:card_parts, { card_set: :card_block }, :card_types, :collections, :colors).display_order.page(params[:page]).per(200)
    @sets = @cards.group_by(&:card_set).sort_by { |card_set, _| card_set.release_date }
  end

  private

  def find_card_list
    return nil if params[:list_id].blank?

    CardList.find_by!(user_id: current_user.id, slug: params[:list_id])
  end

  def find_card_set
    CardSet.find_by!(slug: params[:set_id])
  end
end
