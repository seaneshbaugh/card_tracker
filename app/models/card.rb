class Card < ActiveRecord::Base
  attr_accessible :multiverse_id, :name, :card_set_id, :mana_cost, :converted_mana_cost, :card_type, :card_text, :flavor_text, :power, :toughness, :loyalty, :rarity, :card_number, :artist

  belongs_to :card_set

  has_many :collections
  has_many :users, :through => :collections

  validates_presence_of   :multiverse_id
  validates_uniqueness_of :multiverse_id

  validates_presence_of :name

  validates_presence_of :card_set_id

  after_initialize do
    if self.new_record?
      self.multiverse_id = ''
      self.name ||= ''
      self.mana_cost ||= ''
      self.converted_mana_cost ||= ''
      self.card_type ||= ''
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

  def color
    colors = self.mana_cost.downcase.gsub(' ', '-').split(';').reject { |mana| mana =~ /\d|variable-colorless/ }.uniq

    if colors.blank? or self.card_text.downcase =~ /#{self.name} is colorless/
      colors << 'colorless'
    elsif colors.length > 1
      colors << 'multi'
    end

    if self.card_type.downcase =~ /land/
      colors << 'land'
    end

    colors
  end

  def collection_for(user)
    self.collections.select { |collection| collection.user = user }.first
  end
end
