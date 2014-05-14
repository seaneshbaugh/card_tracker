class CardSetPresenter < BasePresenter
  def initialize(card_set, template)
    super

    @card_set = card_set
  end

  def code
    if @card_set.code.present?
      @card_set.code.upcase
    else
      ''
    end
  end

  def release_date
    if @card_set.release_date.present?
      @card_set.release_date.strftime('%Y-%m-%d')
    else
      @template.t('na')
    end
  end

  def prerelease_date
    if @card_set.prerelease_date.present?
      @card_set.prerelease_date.strftime('%Y-%m-%d')
    else
      @template.t('na')
    end
  end

  def show_card_numbers
    if @card_set.show_card_numbers
      @template.t('yes')
    else
      @template.t('no')
    end
  end

  def card_block_name
    @card_set.card_block.name
  end

  def card_block_type_name
    @card_set.card_block.card_block_type.name
  end

  def symbol(options = {})
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

    options[:class] = options[:class].split(' ').push('set-symbol').push(rarity).push("set-#{@card_set.code.downcase}").push(options[:size]).join(' ')

    options[:alt] ||= @card_set.name

    options[:title] ||= @card_set.name

    "<i class=\"#{options[:class]}\" title=\"#{options[:title]}\" rel=\"tooltip\"></i>".html_safe
  end
end
