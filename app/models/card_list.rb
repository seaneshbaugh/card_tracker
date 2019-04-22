# frozen_string_literal: true

class CardList < ActiveRecord::Base
  DEFAULT_LISTS = [
    { name: 'Have', have: true, order: 0, default: true },
    { name: 'Want', have: false, order: 1, default: false },
    { name: 'Have (foil)', have: true, order: 2, default: false },
    { name: 'Want (foil)', have: false, order: 3, default: false }
  ].freeze

  belongs_to :user
  has_many :collections, dependent: :destroy
  has_many :cards, through: :collections

  validates :user_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :slug, presence: true, uniqueness: { scope: :user_id }
  validates :have, inclusion: { in: [true, false] }
  validates :order, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2_147_483_647 }, presence: true
  validates :default, inclusion: { in: [true, false] }

  after_initialize :set_default_attribute_values, if: :new_record?
  before_validation :generate_slug
  before_save :ensure_only_one_default

  protected

  def generate_slug
    if self.name.blank?
      self.slug = self.id.to_s
    else
      self.slug = CGI.unescapeHTML(Sanitize.clean(self.name)).gsub(/'|"/, '').gsub('&', 'and').squeeze(' ').parameterize
    end
  end

  private

  def ensure_only_one_default
    return unless default && default_changed?

    CardList.where(user_id: user_id).where.not(id: id).update_all(default: false)
  end

  def set_default_attribute_values
    self.have = true if have.nil?
    self.order ||= 0
  end
end
