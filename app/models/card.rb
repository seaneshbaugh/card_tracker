# frozen_string_literal: true

class Card < ApplicationRecord
  belongs_to :card_set, inverse_of: :cards
  belongs_to :layout, foreign_key: :layout_code, inverse_of: :cards, primary_key: :layout_code
  belongs_to :rarity, foreign_key: :rarity_code, inverse_of: :cards, primary_key: :rarity_code
  has_many :card_colorings, dependent: :restrict_with_exception, inverse_of: :card
  has_many :card_super_typings, dependent: :restrict_with_exception, inverse_of: :card
  has_many :card_typings, dependent: :restrict_with_exception, inverse_of: :card
  has_many :card_sub_typings, dependent: :restrict_with_exception, inverse_of: :card
  has_many :card_parts, dependent: :restrict_with_exception, inverse_of: :card
  has_many :collections, dependent: :restrict_with_exception, inverse_of: :card
  has_many :colors, through: :card_colorings, foreign_key: :color_code, inverse_of: :cards
  has_many :card_super_types, through: :card_super_typings, foreign_key: :card_super_type_code, inverse_of: :cards
  has_many :card_types, through: :card_typings, foreign_key: :card_type_code, inverse_of: :cards
  has_many :card_sub_types, through: :card_sub_typings, foreign_key: :card_sub_type_code, inverse_of: :cards
  has_many :card_lists, through: :collections, inverse_of: :cards
  has_many :users, through: :collections, inverse_of: :cards

  scope :display_order, -> { order(Arel.sql('SUBSTRING("cards"."card_number", \'^[0-9]+\')::INTEGER, SUBSTRING("cards"."card_number", \'[^0-9]*$\')')) }

  validates :name, presence: true
  validates :type_text, presence: true
  validates :card_number, presence: true
  validates :artist, presence: true

  Color.find_each do |color|
    define_method("#{color.name.downcase}?") do
      colors.include?(Color.find_by(color_code: color.color_code))
    end
  end

  def addible?
    !placeholder?
  end

  def colorless?
    colors.length.zero?
  end

  def monocolored?
    colors.length == 1
  end

  def multicolored?
    colors.length > 1
  end

  def land?
    card_types.find { |card_type| card_type.card_type_code == 'LAND' }.present?
  end

  def placeholder?
    layout_code == 'MELD' && card_number.ends_with?('b')
  end

  def collection_for(user, card_list)
    if collections.loaded?
      collections.select { |collection| collection.user_id == user.id && collection.card_list_id == card_list.id }.first
    else
      collections.find_by(user_id: user.id, card_list_id: card_list.id)
    end
  end

  def other_versions
    self.class.includes(:card_set).where(name: name).where.not(id: id).order('card_sets.release_date ASC')
  end

  # def <=>(other)
  #   if card_set_id == other.card_set_id
  #     card_number.to_i <=> other.card_number.to_i
  #   elsif card_set.card_block.card_block_type_id != other.card_set.card_block.card_block.card_block_type_id
  #     card_set.card_block.card_block_type_id <=> other.card_set.card_block.card_block.card_block_type_id
  #   elsif card_set.card_block_id != other.card_set.card_block_id
  #     card_set.card_block.card_sets.first.release_date <=> other.card_set.card_block.card_sets.first.release_date
  #   else
  #     card_set.release_date <=> other.card_set.release_date
  #   end
  # end
end
