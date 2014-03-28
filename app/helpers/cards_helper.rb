module CardsHelper
  def mana_cost(card, options = {})
    mana_symbols = {
      'White' => 'w',
      'Blue' => 'u',
      'Black' => 'b',
      'Red' => 'r',
      'Green' => 'g',
      'Phyrexian White' => 'wp',
      'Phyrexian Blue' => 'up',
      'Phyrexian Black' => 'bp',
      'Phyrexian Red' => 'rp',
      'Phyrexian Green' => 'gp',
      'Phyrexian Colorless' => 'cp',
      'White or Blue' => 'wu',
      'White or Black' => 'wb',
      'Blue or Black' => 'ub',
      'Blue or Red' => 'ur',
      'Black or Red' => 'br',
      'Black or Green' => 'bg',
      'Red or White' => 'rw',
      'Red or Green' => 'rg',
      'Green or White' => 'gw',
      'Green or Blue' => 'gu',
      'Two or White' => '2w',
      'Two or Blue' => '2u',
      'Two or Black' => '2b',
      'Two or Red' => '2r',
      'Two or Green' => '2g',
      'Variable Colorless' => 'x',
      'Snow' => 'snow',
      'Infinity' => 'i'
    }

    options[:class] ||= ''

    card.mana_cost.split(';').map do |mana|
      mana_symbol = mana_symbols[mana]

      mana_symbol ||= mana.parameterize

      klass = options[:class].split(' ').push('mana-symbol').push(options[:size]).push("symbol-#{mana_symbol}").join(' ').squeeze(' ')

      "<i class=\"#{klass}\"></i>"
    end.join.html_safe
  end

  def card_tooltip_text(card)
    if card.card_set.show_card_numbers? && card.card_number.present?
      "<p class='mana-cost'>#{mana_cost(card, :size => 'small').gsub("\"", "'")}</p><p class='card-text'>#{CGI.escapeHTML(card.card_text)}</p><hr><p class='flavor-text'>#{CGI.escapeHTML(card.flavor_text)}</p><p class='card-number'>Card Number: #{card.card_number}</p><p class='artist'>Artist: #{CGI.escapeHTML(card.artist)}</p>".html_safe
    else
      "<p class='mana-cost'>#{mana_cost(card, :size => 'small').gsub("\"", "'")}</p><p class='card-text'>#{CGI.escapeHTML(card.card_text)}</p><hr><p class='flavor-text'>#{CGI.escapeHTML(card.flavor_text)}</p><p class='artist'>Artist: #{CGI.escapeHTML(card.artist)}</p>".html_safe
    end
  end
end
