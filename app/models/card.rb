class Card < ActiveRecord::Base
  attr_accessible :multiverse_id, :name, :card_set_id, :layout, :mana_cost, :converted_mana_cost, :colors, :card_type, :card_supertypes, :card_types, :card_subtypes, :card_text, :flavor_text, :power, :toughness, :loyalty, :rarity, :card_number, :artist

  belongs_to :card_set

  has_many :card_parts
  has_many :collections
  has_many :users, :through => :collections

  validates_presence_of :multiverse_id

  validates_presence_of :name

  validates_presence_of :card_set_id

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

  %w(White Blue Black Red Green).each do |color|
    define_method("is_#{color.downcase}?") do
      self.colors.split(';').include? color
    end
  end

  def is_multi?
    self.colors.split(';').length > 0
  end

  def is_colorless?
    self.colors.blank?
  end

  def is_land?
    self.card_types.split(';').include?('Land')
  end

  def collection_for(user)
    self.collections.where(:user_id => user.id).first
  end

  def other_versions
    Card.includes(:card_set).where('`cards`.`name` = ? AND `cards`.`id` <> ?', self.name, self.id)
  end

  def <=>(other)
    if self.card_set_id == other.card_set_id
      self.card_number.to_i <=> other.card_number.to_i
    else
      if self.card_set.card_block.card_block_type_id != other.card_set.card_block.card_block.card_block_type_id
        self.card_set.card_block.card_block_type_id <=> other.card_set.card_block.card_block.card_block_type_id
      else
        if self.card_set.card_block_id != other.card_set.card_block_id
          self.card_set.card_block.card_sets.first.release_date <=> other.card_set.card_block.card_sets.first.release_date
        else
          self.card_set.release_date <=> other.card_set.release_date
        end
      end
    end
  end
end
