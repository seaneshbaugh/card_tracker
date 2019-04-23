# frozen_string_literal: true

class CardPresenter < BasePresenter
  def initialize(card, template)
    super

    @card = card
  end

  def colors
    @card.colors.map(&:name).join(', ')
  end

  # TODO: Use https://github.com/andrewgioia/Mana.
  def mana_cost(options = {})
    options[:class] ||= ''

    @card.mana_cost.delete('{').split('}').map do |mana|
      mana_symbol = mana.delete('/').downcase

      klass = options[:class].split(' ').push('mana-symbol').push(options[:size]).push("symbol-#{mana_symbol}").join(' ').squeeze(' ')

      "<i class=\"#{klass}\"></i>"
    end.join.html_safe
  end

  def card_supertypes
    @card.card_supertypes.map(&:name).join(', ')
  end

  def card_types
    @card.card_types.map(&:name).join(', ')
  end

  def card_subtypes
    @card.card_subtypes.map(&:name).join(', ')
  end

  def card_text(options = {})
    options[:class] ||= ''

    @card.card_text.gsub(/(\{[A-Z|\d|\/]+\})/) do |match|
      mana_symbol = match.delete(/\{|\}|\//).downcase

      klass = options[:class].split(' ').push('mana-symbol').push(options[:size]).push("symbol-#{mana_symbol}").join(' ').squeeze(' ')

      "<i class=\"#{klass}\"></i>"
    end.html_safe
  end

  def flavor_text
    @card.flavor_text.html_safe
  end

  def power_toughness
    return unless @card.power.present? && @card.toughness.present?

    power = content_tag(:span, @card.power, class: 'power')
    toughness = content_tag(:span, @card.toughness, class: 'toughness')

    safe_join([power, toughness], ' / ')
  end

  def card_set_name
    @card.card_set.name
  end

  def card_set_slug
    @card.card_set.slug
  end

  def card_block_name
    @card.card_set.card_block.name
  end

  def card_set_type_name
    @card.card_set.card_set_type.name
  end

  def color_class
    if colorless?
      if @card.land?
        'land'
      else
        'colorless'
      end
    elsif colors.length == 1
      colors.first.downcase
    else
      colored_mana = @card.mana_cost.delete('{').split('}').uniq.select { |mana| mana.match(/W|U|B|R|G/) }

      if colored_mana.empty? || colored_mana.length > 1
        if @card.layout == 'double-faced'
          "double-faced-#{@card.card_parts.first.colors.map(&:name).join('-').downcase}-to-#{@card.card_parts.last.colors.map(&:name).join('-').downcase}"
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
          'G/U' => 'green-or-blue'
        }[colored_mana.first]
      end
    end
  end

  def partial_name
    @card.layout.underscore
  end
end
