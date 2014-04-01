module CardsHelper
  def mana_cost(card, options = {})
    options[:class] ||= ''

    card.mana_cost.gsub('{', '').split('}').map do |mana|
      mana_symbol = mana.gsub('/', '').downcase

      klass = options[:class].split(' ').push('mana-symbol').push(options[:size]).push("symbol-#{mana_symbol}").join(' ').squeeze(' ')

      "<i class=\"#{klass}\"></i>"
    end.join.html_safe
  end

  def card_text_with_symbols(card_text, options = {})
    options[:class] ||= ''

    card_text.gsub(/(\{[A-Z|\d|\/]+\})/) do |match|
      mana_symbol = match.gsub(/\{|\}|\//, '').downcase

      klass = options[:class].split(' ').push('mana-symbol').push(options[:size]).push("symbol-#{mana_symbol}").join(' ').squeeze(' ')

      "<i class=\"#{klass}\"></i>"
    end.html_safe
  end

  def card_tooltip_text(card)
    if card.card_set.show_card_numbers? && card.card_number.present?
      "<p class='mana-cost'>#{mana_cost(card, :size => 'small').gsub("\"", "'")}</p><p class='card-text'>#{CGI.escapeHTML(card_text_with_symbols(card.card_text, :size => 'small'))}</p><hr><p class='flavor-text'>#{CGI.escapeHTML(card.flavor_text)}</p><p class='card-number'>Card Number: #{card.card_number}</p><p class='artist'>Artist: #{CGI.escapeHTML(card.artist)}</p>".html_safe
    else
      "<p class='mana-cost'>#{mana_cost(card, :size => 'small').gsub("\"", "'")}</p><p class='card-text'>#{CGI.escapeHTML(card_text_with_symbols(card.card_text, :size => 'small'))}</p><hr><p class='flavor-text'>#{CGI.escapeHTML(card.flavor_text)}</p><p class='artist'>Artist: #{CGI.escapeHTML(card.artist)}</p>".html_safe
    end
  end

  def color_class(card)
    colors = card.colors.split(';')

    if colors.length == 0
      if card.card_types.include?('Land')
        'land'
      else
        'colorless'
      end
    elsif colors.length == 1
      colors.first.downcase
    else
      colored_mana = card.mana_cost.gsub('{', '').split('}').uniq.reject { |mana| !mana.match(/W|U|B|R|G/) }

      if colored_mana.length == 0 || colored_mana.length > 1 #|| colored_mana.reject { |mana| !mana.match(/\//) || mana.match(/\d/) }.length == 0
        'multi'
      else
        {
          'W/U' => 'white-or-blue',
          'W/B' => 'white-or-black',
          'U/B' => 'blue-or-black',
          'U/R' => 'blue-or-red',
          'B/R' => 'black-or-red',
          'B/G' => 'black-or-green',
          'R/W' => 'red-or-white',
          'R/G' => 'red-or-green',
          'G/W' => 'green-or-white',
          'G/U' => 'green-or-blue',
        }[colored_mana.first]
      end
    end
  end
end
