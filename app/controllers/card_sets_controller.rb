# frozen_string_literal: true

class CardSetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @card_list = find_card_list

    @card_sets = find_card_sets
  end

  private

  def find_card_list
    return nil unless params[:list_id].present?

    CardList.find_by!(user_id: current_user.id, slug: params[:list_id])
  end

  def find_card_sets
    # TODO: Make this be a scope. See https://stackoverflow.com/a/29086676.
    @card_sets = CardSet.includes(card_block: :card_block_type).order('"card_block_types"."id" ASC').order('"card_blocks"."id" ASC').order('"card_sets"."release_date" ASC')
  end
end
