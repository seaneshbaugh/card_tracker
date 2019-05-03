# frozen_string_literal: true

module CardSetsHelper
  def card_set_symbol(card_set, options = {})
    options[:rarity] ||= :common

    rarity = case options[:rarity].to_sym
             when :common
               'c'
             when :uncommon
               'u'
             when :rare
               'r'
             when :mythic
               'm'
             else
               'c'
             end

    options[:class] ||= ''

    options[:class] = options[:class].split(' ').push('set-symbol').push(rarity).push("set-#{card_set.code.downcase}").push(options[:size]).join(' ')

    options[:alt] ||= card_set.name

    options[:title] ||= card_set.name

    "<i class=\"#{options[:class]}\" title=\"#{options[:title]}\" rel=\"tooltip\"></i>".html_safe
  end
end
