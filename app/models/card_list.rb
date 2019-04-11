class CardList < ActiveRecord::Base
#  attr_accessible :user_id, :name, :slug, :have, :order, :default

  belongs_to :user

  has_many :collections
  has_many :cards, :through => :collections

  validates_presence_of :user_id

  validates_presence_of   :name
  validates_uniqueness_of :name, :scope => :user_id

  validates_presence_of   :slug
  validates_uniqueness_of :slug, :scope => :user_id

  validates_inclusion_of :have, :in => [true, false]

  validates_numericality_of :order, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 2_147_483_647
  validates_presence_of     :order

  validates_inclusion_of :default, :in => [true, false]

  after_initialize do
    if self.new_record?
      self.name ||= ''
      self.slug ||= ''

      if self.have.nil?
        self.have = true
      end

      self.order ||= 0
    end
  end

  before_validation :generate_slug

  before_save do
    if self.default && self.default_changed?
      card_lists = CardList.where('`card_lists`.`id` != ? AND `card_lists`.`user_id` = ?', self.id, self.user_id)

      card_lists.each do |card_list|
        card_list.update_column :default, false
      end
    end
  end

  protected

  def generate_slug
    if self.name.blank?
      self.slug = self.id.to_s
    else
      self.slug = CGI.unescapeHTML(Sanitize.clean(self.name)).gsub(/'|"/, '').gsub('&', 'and').squeeze(' ').parameterize
    end
  end
end
