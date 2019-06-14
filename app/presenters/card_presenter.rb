# frozen_string_literal: true

class CardPresenter < BasePresenter
  def initialize(card, template)
    super

    @card = card
  end

  def colors
    @card.colors.map(&:name).join(', ')
  end

  def mana_cost(options = {})
    return unless @card.mana_cost

    size = options[:size]

    other_classes = Array(options[:class])

    mana_symbols = @card.mana_cost.delete('{').split('}').map do |mana|
      mana_symbol = mana.delete('/').downcase

      ms_classes = [mana_symbol, size, 'fw', 'cost'].compact.map { |option| "ms-#{option}" }.unshift('ms')

      content_tag(:i, '', class: ms_classes.concat(other_classes), alt: mana_symbol, title: mana_symbol)
    end

    safe_join(mana_symbols, '')
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
    return unless @card.card_text

    @card.card_text.gsub(%r{(\{[A-Z|\d|/]+\})}) do |match|
      mana_symbol = translate_mana_symbol(match.gsub(/\{|\}|\//, '').downcase)

      ms_classes = [mana_symbol, 'cost'].compact.map { |option| "ms-#{option}" }.unshift('ms')

      content_tag(:i, '', class: ms_classes, alt: mana_symbol, title: mana_symbol)
    end.html_safe
  end

  def flavor_text
    @card.flavor_text&.html_safe
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
    elsif monocolored?
      @card.colors.first.name.downcase
    else
      colored_mana = (@card.mana_cost || '').delete('{').split('}').uniq.select { |mana| mana.match(/W|U|B|R|G/) }

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

  def gatherer_uri
    "https://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=#{@card.multiverse_id}"
  end

  # TODO: Make default "No Image Available" image for when card has no Scryfall ID.
  def image_uri(size = 'normal')
    raise 'Invalid image size.' unless %w[small normal large png art_crop border_crop].include?(size)

    return '' unless @card.scryfall_id

    extension = size == 'png' ? 'png' : 'jpg'

    "https://img.scryfall.com/cards/#{size}/front/#{@card.scryfall_id[0]}/#{@card.scryfall_id[1]}/#{@card.scryfall_id}.#{extension}"
  end

  def partial_name
    @card.layout_code.underscore
  end

  def rarity
    @card.rarity.name
  end

  private

  def translate_mana_symbol(mana_symbol)
    case mana_symbol
    when 't'
      'tap'
    else
      mana_symbol
    end
  end
end
