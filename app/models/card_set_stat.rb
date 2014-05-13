class CardSetStat
  attr_accessor :card_set, :user, :cards_in_set, :unique_cards, :total_cards, :percent_collected, :rarity, :common_cards_in_set, :unique_common_cards, :total_common_cards, :uncommon_cards_in_set, :unique_uncommon_cards, :total_uncommon_cards, :rare_cards_in_set, :unique_rare_cards, :total_rare_cards, :mythic_rare_cards_in_set, :unique_mythic_rare_cards, :total_mythic_rare_cards

  def initialize(card_set, user)
    self.card_set = card_set

    self.user = user

    self.cards_in_set = card_set.cards.count

    self.unique_cards = Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ?', user.id, card_set.id).select('distinct `collections`.`card_id`').count

    self.total_cards = Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ?', user.id, card_set.id).sum(:quantity)

    if self.cards_in_set > 0
      self.percent_collected = ((self.unique_cards.to_f / self.cards_in_set.to_f) * 100.0).to_i
    else
      self.percent_collected = 0
    end

    if self.unique_cards == self.cards_in_set
      self.rarity = :rare
    else
      self.rarity = :common
    end
  end

  def get_rarity_stats
    self.common_cards_in_set = Card.where(:card_set_id => card_set.id, :rarity => 'Common').count

    self.unique_common_cards = Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ? AND `cards`.`rarity` = ?', self.user.id, self.card_set.id, 'Common').select('distinct `collections`.`card_id`').count

    self.total_common_cards = Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ? AND `cards`.`rarity` = ?', self.user.id, self.card_set.id, 'Common').sum(:quantity)

    self.uncommon_cards_in_set = Card.where(:card_set_id => card_set.id, :rarity => 'Uncommon').count

    self.unique_uncommon_cards = Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ? AND `cards`.`rarity` = ?', self.user.id, self.card_set.id, 'Uncommon').select('distinct `collections`.`card_id`').count

    self.total_uncommon_cards = Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ? AND `cards`.`rarity` = ?', self.user.id, self.card_set.id, 'Uncommon').sum(:quantity)

    self.rare_cards_in_set = Card.where(:card_set_id => card_set.id, :rarity => 'Rare').count

    self.unique_rare_cards = Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ? AND `cards`.`rarity` = ?', self.user.id, self.card_set.id, 'Rare').select('distinct `collections`.`card_id`').count

    self.total_rare_cards = Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ? AND `cards`.`rarity` = ?', self.user.id, self.card_set.id, 'Rare').sum(:quantity)

    self.mythic_rare_cards_in_set = Card.where(:card_set_id => card_set.id, :rarity => 'Mythic Rare').count

    self.unique_mythic_rare_cards = Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ? AND `cards`.`rarity` = ?', self.user.id, self.card_set.id, 'Mythic Rare').select('distinct `collections`.`card_id`').count

    self.total_mythic_rare_cards = Collection.joins(:card_list, :card).where('`collections`.`user_id` = ? AND `collections`.`quantity` <> 0 AND `card_lists`.`have` = 1 AND `cards`.`card_set_id` = ? AND `cards`.`rarity` = ?', self.user.id, self.card_set.id, 'Mythic Rare').sum(:quantity)
  end
end
