# frozen_string_literal: true

class CardSetPresenter < BasePresenter
  def initialize(card_set, template)
    super

    @card_set = card_set
  end

  def release_date
    @card_set.release_date.strftime(date_format)
  end

  def card_block_name
    @card_set.card_block.name
  end

  def card_set_type_name
    @card_set.card_set_type.name
  end

  def symbol(options = {})
    size = options[:size]
    fixed_width = 'fw' if options[:fixed_width]
    rarity = options[:rarity] || 'common'
    gradient = 'grad' if options[:gradient]
    foil = 'foil' if options[:foil]

    ss_classes = [@card_set.code.downcase, size, fixed_width, rarity, gradient, foil].compact.map { |option| "ss-#{option}" }.unshift('ss')

    content_tag(:i, '', class: ss_classes, alt: @card_set.name, title: @card_set.name)
  end
end
