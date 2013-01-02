class Card < ActiveRecord::Base
  attr_accessible :multiverse_id, :name, :card_set_id, :mana_cost, :converted_mana_cost, :card_type, :card_text, :flavor_text, :power, :toughness, :loyalty, :rarity, :card_number, :artist

  belongs_to :card_set

  has_many :collections
  has_many :users, :through => :collections

  validates_presence_of   :multiverse_id
  validates_uniqueness_of :multiverse_id

  validates_presence_of :name

  validates_presence_of :card_set_id
end
