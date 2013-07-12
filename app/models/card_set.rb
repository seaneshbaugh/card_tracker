class CardSet < ActiveRecord::Base
  attr_accessible :name, :card_block_id, :code, :release_date, :prerelease_date

  belongs_to :card_block

  has_many :cards

  validates_presence_of   :name
  validates_uniqueness_of :name

  validates_presence_of :card_block_id

  after_initialize do
    if self.new_record?
      self.name ||= ''
      self.code ||= ''
    end
  end
end
