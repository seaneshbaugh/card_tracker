# frozen_string_literal: true

class CardSetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @card_list = find_card_list
    @card_sets = find_card_sets
  end

  private

  def find_card_list
    return nil if params[:list_id].blank?

    CardList.find_by!(user_id: current_user.id, slug: params[:list_id])
  end

  def find_card_sets
    @card_sets = CardSet.display_order
  end
end
