# frozen_string_literal: true

class CardList < ApplicationRecord
  extend FriendlyId

  DEFAULT_LISTS = [
    { name: 'Have', have: true, order: 0, default: true },
    { name: 'Want', have: false, order: 1, default: false },
    { name: 'Have (foil)', have: true, order: 2, default: false },
    { name: 'Want (foil)', have: false, order: 3, default: false }
  ].freeze

  belongs_to :user, inverse_of: :card_lists
  has_many :collections, dependent: :destroy, inverse_of: :card_list
  has_many :cards, through: :collections, inverse_of: :card_list

  scope :display_order, -> { order(order: :asc) }

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :have, inclusion: { in: [true, false] }
  validates :order, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2_147_483_647 }, presence: true
  validates :default, inclusion: { in: [true, false] }

  after_initialize :set_default_attribute_values, if: :new_record?
  before_save :ensure_only_one_default

  friendly_id :name, use: :scoped, scope: :user_id

  def normalize_friendly_id(value)
    CGI.unescapeHTML(Sanitize.clean(value.to_s.gsub(' & ', ' and '))).gsub(/'|"/, '').delete('&').squeeze(' ').gsub('_', '-').parameterize
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  private

  def ensure_only_one_default
    return unless default && default_changed?

    CardList.where(user_id: user_id).where.not(id: id).find_each do |card_list|
      card_list.update(default: false)
    end
  end

  def set_default_attribute_values
    self.have = true if have.nil?
    self.order ||= 0
    self.default = false if default.nil?
  end
end
