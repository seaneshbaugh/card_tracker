class CardPart < ActiveRecord::Base
  attr_accessible :multiverse_id, :name, :card_id, :layout, :mana_cost, :converted_mana_cost, :colors, :card_type, :card_supertypes, :card_types, :card_subtypes, :card_text, :flavor_text, :power, :toughness, :loyalty, :rarity, :card_number, :artist

  belongs_to :card

  delegate :card_set, :to => :card, :allow_nil => true

  validates_presence_of :multiverse_id

  validates_presence_of :name

  validates_presence_of :card_id

  after_initialize do
    if self.new_record?
      self.multiverse_id ||= ''
      self.name ||= ''
      self.layout ||= ''
      self.mana_cost ||= ''
      self.converted_mana_cost ||= ''
      self.colors ||= ''
      self.card_type ||= ''
      self.card_supertypes ||= ''
      self.card_types ||= ''
      self.card_subtypes ||= ''
      self.card_text ||= ''
      self.flavor_text ||= ''
      self.power ||= ''
      self.toughness ||= ''
      self.loyalty ||= ''
      self.rarity ||= ''
      self.card_number ||= ''
      self.artist ||= ''
    end
  end
end
