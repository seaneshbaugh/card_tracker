# frozen_string_literal: true

class CardSet < ApplicationRecord
  belongs_to :card_set_type
  belongs_to :card_block, optional: true
  has_many :cards, dependent: :restrict_with_exception, inverse_of: :card_set

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true

  before_validation :generate_slug

  protected

  def generate_slug
    if self.name.blank?
      self.slug = self.id.to_s
    else
      self.slug = CGI.unescapeHTML(Sanitize.clean(self.name)).gsub(/'|"/, '').gsub('&', 'and').squeeze(' ').parameterize
    end
  end
end
