class CardSet < ActiveRecord::Base
  attr_accessible :name, :slug, :card_block_id, :code, :release_date, :prerelease_date

  belongs_to :card_block

  has_many :cards

  validates_presence_of   :name
  validates_uniqueness_of :name

  validates_presence_of   :slug
  validates_uniqueness_of :slug

  validates_presence_of :card_block_id

  after_initialize do
    if self.new_record?
      self.name ||= ''
      self.slug ||= ''
      self.code ||= ''
    end
  end

  before_validation :generate_slug

  protected

  def generate_slug
    if self.name.blank?
      self.slug = self.id.to_s
    else
      self.slug = self.name.parameterize
    end
  end
end
