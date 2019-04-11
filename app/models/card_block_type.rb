class CardBlockType < ActiveRecord::Base
#  attr_accessible :name

  has_many :card_blocks

  validates_presence_of   :name
  validates_uniqueness_of :name

  after_initialize do
    if self.new_record?
      self.name ||= ''
    end
  end
end
