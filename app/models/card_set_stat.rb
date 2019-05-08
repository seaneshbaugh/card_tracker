# frozen_string_literal: true

class CardSetStat
  extend Memoist

  attr_accessor :card_set, :user

  def initialize(card_set, user)
    @card_set = card_set
    @user = user
  end

  def cards_in_set
    card_set.cards.count
  end
  memoize :cards_in_set

  def unique_cards
    Collection.joins(:card_list, :card).where(user_id: user.id).where.not(quantity: 0).where(card_lists: { have: true }, cards: { card_set_id: card_set.id }).distinct(:card_id).count
  end
  memoize :unique_cards

  def unique_cards_in_list(card_list)
    Collection.joins(:card_list, :card).where(user_id: user.id).where.not(quantity: 0).where(card_lists: { id: card_list.id, have: true }, cards: { card_set_id: card_set.id }).distinct(:card_id).count
  end
  memoize :unique_cards_in_list

  def total_cards
    Collection.joins(:card_list, :card).where(user_id: user.id).where.not(quantity: 0).where(card_lists: { have: true }, cards: { card_set_id: card_set.id }).sum(:quantity)
  end
  memoize :total_cards

  def total_cards_in_list(card_list)
    Collection.joins(:card_list, :card).where(user_id: user.id).where.not(quantity: 0).where(card_lists: { id: card_list.id, have: true }, cards: { card_set_id: card_set.id }).sum(:quantity)
  end
  memoize :total_cards_in_list

  def percent_collected
    return 0 unless cards_in_set.positive?

    ((unique_cards.to_f / cards_in_set.to_f) * 100.0).to_i
  end
  memoize :percent_collected

  def percent_collected_in_list(card_list)
    return 0 unless cards_in_set.positive?

    ((unique_cards_in_list(card_list).to_f / cards_in_set.to_f) * 100.0).to_i
  end
  memoize :percent_collected_in_list

  def rarity
    if unique_cards == cards_in_set
      :rare
    else
      :common
    end
  end
  memoize :rarity

  Rarity.find_each do |rarity|
    rarity_underscored = rarity.name.parameterize.underscore

    cards_in_set_method_name = "#{rarity_underscored}_cards_in_set".to_sym

    define_method cards_in_set_method_name do
      Card.where(card_set_id: card_set.id, rarity_code: rarity.rarity_code).count
    end
    memoize cards_in_set_method_name

    unique_cards_method_name = "unique_#{rarity_underscored}_cards".to_sym

    define_method unique_cards_method_name do
      Collection.joins(:card_list, :card).where(user_id: user.id).where.not(quantity: 0).where(card_lists: { have: true }, cards: { card_set_id: card_set.id, rarity_code: rarity.rarity_code }).distinct(:card_id).count
    end
    memoize unique_cards_method_name

    unique_cards_in_list_method_name = "unique_#{rarity_underscored}_cards_in_list".to_sym

    define_method unique_cards_in_list_method_name do |card_list|
      Collection.joins(:card_list, :card).where(user_id: user.id).where.not(quantity: 0).where(card_lists: { id: card_list.id, have: true }, cards: { card_set_id: card_set.id, rarity_code: rarity.rarity_code }).distinct(:card_id).count
    end
    memoize unique_cards_in_list_method_name

    total_cards_method_name = "total_#{rarity_underscored}_cards".to_sym

    define_method total_cards_method_name do
      Collection.joins(:card_list, :card).where(user_id: user.id).where.not(quantity: 0).where(card_lists: { have: true }, cards: { card_set_id: card_set.id, rarity_code: rarity.rarity_code }).sum(:quantity)
    end
    memoize total_cards_method_name

    total_cards_in_list_method_name = "total_#{rarity_underscored}_cards_in_list".to_sym

    define_method total_cards_in_list_method_name do |card_list|
      Collection.joins(:card_list, :card).where(user_id: user.id).where.not(quantity: 0).where(card_lists: { id: card_list.id, have: true }, cards: { card_set_id: card_set.id, rarity_code: rarity.rarity_code }).sum(:quantity)
    end
    memoize total_cards_in_list_method_name
  end
end
