class CardPresenter < BasePresenter
  def initialize(card, template)
    super

    @card = card
  end

  def colors
    @card.colors.gsub(';', ', ')
  end

  def mana_cost(options = {})
    options[:class] ||= ''

    @card.mana_cost.gsub('{', '').split('}').map do |mana|
      mana_symbol = mana.gsub('/', '').downcase

      klass = options[:class].split(' ').push('mana-symbol').push(options[:size]).push("symbol-#{mana_symbol}").join(' ').squeeze(' ')

      "<i class=\"#{klass}\"></i>"
    end.join.html_safe
  end

  def card_supertypes
    @card.card_supertypes.gsub(';', ', ')
  end

  def card_types
    @card.card_types.gsub(';', ', ')
  end

  def card_subtypes
    @card.card_subtypes.gsub(';', ', ')
  end

  def card_text(options = {})
    options[:class] ||= ''

    @card.card_text.gsub(/(\{[A-Z|\d|\/]+\})/) do |match|
      mana_symbol = match.gsub(/\{|\}|\//, '').downcase

      klass = options[:class].split(' ').push('mana-symbol').push(options[:size]).push("symbol-#{mana_symbol}").join(' ').squeeze(' ')

      "<i class=\"#{klass}\"></i>"
    end.html_safe
  end

  def flavor_text
    @card.flavor_text.html_safe
  end

  def power_toughness
    pt = ''

    if @card.power.present? && @card.toughness.present?
      pt += "<span class=\"power\">#{@card.power}</span> / <span class=\"toughness\">#{@card.toughness}</span>"
    end

    pt.html_safe
  end

  def card_number
    if @card.card_set.show_card_numbers? && @card.card_number.present?
      @card.card_number
    else
      ''
    end
  end

  def card_set_name
    @card.card_set.name
  end

  def card_block_name
    @card.card_set.card_block.name
  end

  def card_block_type_name
    @card.card_set.card_block.card_block_type.name
  end

  def color_class
    colors = @card.colors.split(';')

    if colors.length == 0
      if @card.card_types.include?('Land')
        'land'
      else
        'colorless'
      end
    elsif colors.length == 1
      colors.first.downcase
    else
      colored_mana = @card.mana_cost.gsub('{', '').split('}').uniq.reject { |mana| !mana.match(/W|U|B|R|G/) }

      if colored_mana.length == 0 || colored_mana.length > 1
        if @card.layout == 'double-faced'
          "double-faced-#{@card.card_parts.first.colors.split(';').join('-').downcase}-to-#{@card.card_parts.last.colors.split(';').join('-').downcase}"
        else
          'multi'
        end
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

  def partial_name
    @card.layout.underscore
  end
end
