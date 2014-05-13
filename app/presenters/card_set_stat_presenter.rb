class CardSetStatPresenter < BasePresenter
  def initialize(card_set_stat, template)
    super

    @card_set_stat = card_set_stat

    @card_set_presenter = CardSetPresenter.new(@card_set_stat.card_set, @template)
  end

  def card_set_id
    if @card_set_stat.card_set
      @card_set_stat.card_set.id
    end
  end

  def card_set_slug
    if @card_set_stat.card_set
      @card_set_stat.card_set.slug
    end
  end

  def symbol(options = {})
    options[:rarity] = @card_set_stat.rarity

    @card_set_presenter.symbol(options)
  end

  def name
    if @card_set_stat.card_set
      @card_set_stat.card_set.name
    end
  end

  def percent_collected_tooltip_text
    result = []

    result << "#{@card_set_stat.unique_common_cards} / #{@card_set_stat.common_cards_in_set} Common"

    result << "#{@card_set_stat.unique_uncommon_cards} / #{@card_set_stat.uncommon_cards_in_set} Uncommon"

    result << "#{@card_set_stat.unique_rare_cards} / #{@card_set_stat.rare_cards_in_set} Rare"

    if @card_set_stat.mythic_rare_cards_in_set > 0
      result << "#{@card_set_stat.unique_mythic_rare_cards} / #{@card_set_stat.mythic_rare_cards_in_set} Mythic Rare"
    end

    result.join('<br>').html_safe
  end
end
