# frozen_string_literal: true

class StatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_cards_in_collections = Collection.joins(:card_list).where(user_id: current_user.id, card_lists: { have: true }).quantity_greater_than_zero.sum(:quantity)
    @unique_cards_in_collections = Collection.joins(:card_list).where(user_id: current_user.id, card_lists: { have: true }).quantity_greater_than_zero.select(:card_id).count
    @card_sets = CardSet.display_order
    @card_set_stats = @card_sets.map { |card_set| CardSetStat.new(card_set, current_user) }
  end

  def show
    @card_set = CardSet.where(slug: params[:id]).first
    @card_set_stat = CardSetStat.new(@card_set, current_user)
    @card_lists = CardList.where(user_id: current_user.id, have: true).display_order
  end
end
