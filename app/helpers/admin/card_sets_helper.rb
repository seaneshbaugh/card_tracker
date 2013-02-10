module Admin::CardSetsHelper
  def card_set_symbol(card_set, options={})
    options[:rarity] ||= :common

    case options[:rarity]
      when :common
        rarity = 'c'
      when :uncommon
        rarity = 'u'
      when :rare
        rarity = 'r'
      when :mythic
        rarity = 'm'
      else
        rarity = 'c'
    end

    options[:class] ||= ''

    options[:class] = options[:class].split(' ').push('set-symbol').join(' ')

    options[:alt] ||= card_set.name

    options[:title] ||= card_set.name

    image_tag("sets/#{card_set.code.downcase}-#{rarity}.png", :class => options[:class], :alt => options[:alt], :title => options[:title], :rel => 'tooltip')
  end
end
