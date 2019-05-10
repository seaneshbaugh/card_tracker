# frozen_string_literal: true

module CardsHelper
  def card_set_select_options
    CardSet.pluck(:name, :id)
  end

  def card_tooltip_text(card)
    render partial: "cards/tooltip/#{card.layout_code.downcase}", locals: { card: card }
  end
end
