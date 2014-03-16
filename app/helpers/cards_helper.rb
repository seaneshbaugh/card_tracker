module CardsHelper
  def mana_cost(card)
    #TODO: Maybe move this hash to the Card class.
    mana_symbols = {
      'White' => 'W',
      'Blue' => 'U',
      'Black' => 'B',
      'Red' => 'R',
      'Green' => 'G',
      'Phyrexian White' => 'WP',
      'Phyrexian Blue' => 'UP',
      'Phyrexian Black' => 'BP',
      'Phyrexian Red' => 'RP',
      'Phyrexian Green' => 'GP',
      'Phyrexian Colorless' => 'CP',
      'White or Blue' => 'WU',
      'White or Black' => 'WB',
      'Blue or Black' => 'UB',
      'Blue or Red' => 'UR',
      'Black or Red' => 'BR',
      'Black or Green' => 'BG',
      'Red or White' => 'RW',
      'Red or Green' => 'RG',
      'Green or White' => 'GW',
      'Green or Blue' => 'GU',
      'Variable Colorless' => 'X',
      'Snow' => 'snow',
      'Infinity' => 'I'
    }

    card.mana_cost.split(';').map do |mana|
      mana_symbol = mana_symbols[mana]

      mana_symbol ||= mana.upcase

      image_tag("symbols/#{mana_symbol}.png", :alt => mana, :class => "mana-symbol #{mana_symbol.parameterize}")
    end.join.html_safe
  end

  def card_tooltip_text(card)
    if card.card_set.show_card_numbers? && card.card_number.present?
      "<p class='mana-cost'>#{mana_cost(card).gsub("\"", "'")}</p><p class='card-text'>#{CGI.escapeHTML(card.card_text)}</p><hr><p class='flavor-text'>#{CGI.escapeHTML(card.flavor_text)}</p><p class='card-number'>Card Number: #{card.card_number}</p><p class='artist'>Artist: #{CGI.escapeHTML(card.artist)}</p>".html_safe
    else
      "<p class='mana-cost'>#{mana_cost(card).gsub("\"", "'")}</p><p class='card-text'>#{CGI.escapeHTML(card.card_text)}</p><hr><p class='flavor-text'>#{CGI.escapeHTML(card.flavor_text)}</p><p class='artist'>Artist: #{CGI.escapeHTML(card.artist)}</p>".html_safe
    end
  end
end
