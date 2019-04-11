class CardSet < ActiveRecord::Base
#  attr_accessible :name, :slug, :card_block_id, :code, :release_date, :prerelease_date, :show_card_numbers

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

      if self.show_card_numbers.nil?
        self.show_card_numbers = true
      end
    end
  end

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
