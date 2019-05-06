# frozen_string_literal: true

class CardListPresenter < BasePresenter
  def initialize(card_list, template)
    super

    @card_list = card_list
  end

  def total_cards
    @total_cards ||= @card_list.collections.inject(0) { |sum, collection| sum + collection.quantity }
  end

  def unique_cards
    @card_list.collections.select(&:cards?).length
  end
end
