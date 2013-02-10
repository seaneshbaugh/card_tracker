class CardBlock < ActiveRecord::Base
  attr_accessible :name, :card_block_type_id

  belongs_to :card_block_type

  has_many :card_sets, :order => 'release_date ASC'

  validates_presence_of   :name
  validates_uniqueness_of :name

  validates_presence_of :card_block_type_id
end
