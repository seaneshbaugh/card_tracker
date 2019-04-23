# frozen_string_literal: true

class CardSetStatPresenter < BasePresenter
  def initialize(card_set_stat, template)
    super

    @card_set_stat = card_set_stat

    @card_set_presenter = CardSetPresenter.new(@card_set_stat.card_set, @template)
  end

  def card_set_id
    @card_set_stat.card_set&.id
  end

  def card_set_slug
    @card_set_stat.card_set&.slug
  end

  def symbol(options = {})
    options[:rarity] = @card_set_stat.rarity

    @card_set_presenter.symbol(options)
  end

  def name
    @card_set_stat.card_set&.name
  end

  def percent_collected_tooltip_text
    rarities = [
      "#{@card_set_stat.unique_common_cards} / #{@card_set_stat.common_cards_in_set} Common",
      "#{@card_set_stat.unique_uncommon_cards} / #{@card_set_stat.uncommon_cards_in_set} Uncommon",
      "#{@card_set_stat.unique_rare_cards} / #{@card_set_stat.rare_cards_in_set} Rare",
      ("#{@card_set_stat.unique_mythic_rare_cards} / #{@card_set_stat.mythic_rare_cards_in_set} Mythic Rare" if @card_set_stat.mythic_rare_cards_in_set.positive?)
    ].compact

    safe_join(rarities, content_tag('br'))
  end
end
