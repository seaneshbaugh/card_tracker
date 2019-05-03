# frozen_string_literal: true

module CardsHelper
  def card_tooltip_text(card)
    render partial: "cards/tooltip/#{card.layout.underscore}", locals: { card: card }
  end
end
