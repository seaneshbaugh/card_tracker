class CardSetStat
  extend Memoist

  attr_accessor :card_set, :user, :cards_in_set

  def initialize(card_set, user)
    self.card_set = card_set

    self.user = user
  end

  def cards_in_set
    card_set.cards.count
  end
  memoize :cards_in_set

  def unique_cards
    Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ?', user.id, card_set.id).select('distinct `collections`.`card_id`').count
  end
  memoize :unique_cards

  def unique_cards_in_list(card_list)
    Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`id` = ? AND card_lists`.`have` = 1 AND `cards`.`card_set_id` = ?', user.id, card_list.id, card_set.id).select('distinct `collections`.`card_id`').count
  end
  memoize :unique_cards_in_list

  def total_cards
    Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ?', user.id, card_set.id).sum(:quantity)
  end
  memoize :total_cards

  def total_cards_in_list(card_list)
    Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`id` = ? AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ?', user.id, card_list.id, card_set.id).sum(:quantity)
  end
  memoize :total_cards_in_list

  def percent_collected
    if self.cards_in_set > 0
      ((self.unique_cards.to_f / self.cards_in_set.to_f) * 100.0).to_i
    else
      0
    end
  end
  memoize :percent_collected

  def rarity
    if self.unique_cards == self.cards_in_set
      :rare
    else
      :common
    end
  end
  memoize :rarity

  ['Common', 'Uncommon', 'Rare', 'Mythic Rare'].each do |rarity|
    rarity_underscored = rarity.parameterize.underscore

    cards_in_set_method_name = "#{rarity_underscored}_cards_in_set".to_sym

    define_method cards_in_set_method_name do
      Card.where(:card_set_id => card_set.id, :rarity => rarity).count
    end
    memoize cards_in_set_method_name

    unique_cards_method_name = "unique_#{rarity_underscored}_cards".to_sym

    define_method unique_cards_method_name do
      Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ? AND `cards`.`rarity` = ?', self.user.id, self.card_set.id, rarity).select('distinct `collections`.`card_id`').count
    end
    memoize unique_cards_method_name

    unique_cards_in_list_method_name = "unique_#{rarity_underscored}_cards_in_list".to_sym

    define_method unique_cards_in_list_method_name do |card_list|
      Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`id` = ? AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ? AND `cards`.`rarity` = ?', self.user.id, card_list.id, self.card_set.id, rarity).select('distinct `collections`.`card_id`').count
    end
    memoize unique_cards_in_list_method_name

    total_cards_method_name = "total_#{rarity_underscored}_cards".to_sym

    define_method total_cards_method_name do
      Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ? AND `cards`.`rarity` = ?', self.user.id, self.card_set.id, rarity).sum(:quantity)
    end
    memoize total_cards_method_name

    total_cards_in_list_method_name = "total_#{rarity_underscored}_cards_in_list".to_sym

    define_method total_cards_in_list_method_name do |card_list|
      Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`id` = ? AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ? AND `cards`.`rarity` = ?', self.user.id, card_list.id, self.card_set.id, rarity).sum(:quantity)
    end
    memoize total_cards_in_list_method_name
  end
end
