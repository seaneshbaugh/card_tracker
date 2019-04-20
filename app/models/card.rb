# frozen_string_literal: true

class Card < ApplicationRecord
  belongs_to :rarity, foreign_key: :rarity_code, inverse_of: :cards, primary_key: :rarity_code
  belongs_to :card_set
  has_many :card_parts, dependent: :restrict_with_exception
  has_many :collections, dependent: :restrict_with_exception
  has_many :users, through: :collections

  validates :multiverse_id, presence: true
  validates :name, presence: true

  def self.card_supertypes
    uniq.pluck(:card_supertypes).map { |card_supertype| card_supertype.split(';') }.flatten.uniq.reject(&:blank?).sort
  end

  def self.card_types
    uniq.pluck(:card_types).map { |card_type| card_type.split(';') }.flatten.uniq.reject(&:blank?).sort
  end

  def self.card_subtypes
    uniq.pluck(:card_subtypes).map { |card_subtype| card_subtype.split(';') }.flatten.uniq.reject(&:blank?).sort
  end

  %w[White Blue Black Red Green].each do |color|
    define_method("is_#{color.downcase}?") do
      colors.split(';').include? color
    end
  end

  def multi?
    colors.split(';').positive?
  end

  def colorless?
    colors.blank?
  end

  def land?
    card_types.split(';').include?('Land')
  end

  def collection_for(user, card_list)
    if collections.loaded?
      collections.select { |collection| collection.user_id == user.id && collection.card_list_id == card_list.id }.first
    else
      collections.find_by(user_id: user.id, card_list_id: card_list.id)
    end
  end

  def other_versions
    self.class.includes(:card_set).where(card: name).where.not(id: id)
  end

  def <=>(other)
    if card_set_id == other.card_set_id
      card_number.to_i <=> other.card_number.to_i
    elsif card_set.card_block.card_block_type_id != other.card_set.card_block.card_block.card_block_type_id
      card_set.card_block.card_block_type_id <=> other.card_set.card_block.card_block.card_block_type_id
    elsif card_set.card_block_id != other.card_set.card_block_id
      card_set.card_block.card_sets.first.release_date <=> other.card_set.card_block.card_sets.first.release_date
    else
      card_set.release_date <=> other.card_set.release_date
    end
  end
end
