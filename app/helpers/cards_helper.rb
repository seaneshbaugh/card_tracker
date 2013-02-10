module CardsHelper
  def mana_cost(card)
    card.mana_cost.split(';').map do |mana|
      image_tag("mana/#{mana.downcase}", :class => 'mana-symbol')
    end.join
  end
end
