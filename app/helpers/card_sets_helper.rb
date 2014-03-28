module CardSetsHelper
  def card_set_symbol(card_set, options = {})
    options[:rarity] ||= :common

    case options[:rarity].to_sym
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

    options[:class] = options[:class].split(' ').push('set-symbol').push(rarity).push("set-#{card_set.code.downcase}").push(options[:size]).join(' ')

    options[:alt] ||= card_set.name

    options[:title] ||= card_set.name

    "<i class=\"#{options[:class]}\" title=\"#{options[:title]}\" rel=\"tooltip\"></i>".html_safe
  end
end
