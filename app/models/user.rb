class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :confirmable, :lockable, :timeoutable

  attr_accessible :username, :email, :password, :password_confirmation, :role, :first_name, :last_name, :remember_me, :receive_newsletters, :receive_sign_up_alerts, :receive_contact_alerts

  has_many :collections
  has_many :cards, :through => :collections

  validates_format_of     :username, :with => /^[a-z]([a-z0-9_]){4,31}$/
  validates_length_of     :username, :within => 5..32
  validates_presence_of   :username
  validates_uniqueness_of :username

  validates_format_of     :email, :with => Devise.email_regexp, :allow_blank => true
  validates_presence_of   :email
  validates_uniqueness_of :email, :case_sensitive => false

  validates_confirmation_of :password
  validates_length_of       :password, :within => 16..255, :if => :password_required?
  validates_presence_of     :password, :if => :password_required?

  validates_inclusion_of :role, :in => Ability::ROLES.map { |key, value| value }
  validates_presence_of  :role

  after_initialize do
    if self.new_record?
      self.username ||= ''
      self.email ||= ''
      self.encrypted_password ||= ''
      self.role ||= ''
      self.first_name ||= ''
      self.last_name ||= ''

      if self.receive_newsletters.nil?
        self.receive_newsletters ||= true
      end

      if self.receive_contact_alerts.nil?
        self.receive_contact_alerts ||= false
      end

      if self.receive_sign_up_alerts.nil?
        self.receive_sign_up_alerts ||= false
      end

      self.sign_in_count ||= 0
    end
  end

  before_validation :define_role

  after_create do
    @alert_recipients = User.where('users.role != ? AND users.receive_sign_up_alerts = ?', Ability::ROLES[:read_only], true)

    @alert_recipients.each do |alert_recipient|
      RegistrationMailer.delay.new_sign_up_message(alert_recipient, self)
    end

    RegistrationMailer.delay(:run_at => 45.minutes.from_now).welcome_message(self)
  end

  Ability::ROLES.each do |k, v|
    class_eval %Q"scope :#{k.to_s.pluralize}, where(:role => Ability::ROLES[:#{k.to_s}].downcase)"
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def short_name
    "#{self.first_name.first.upcase}. #{self.last_name}"
  end

  Ability::ROLES.each do |k, v|
    define_method("#{k.to_s}?") do
      self.role == k.to_s
    end

    define_method("#{k.to_s}!") do
      self.role = k.to_s
    end
  end

  def ability
    @ability ||= Ability.new(self)
  end

  protected

  def password_required?
    !self.persisted? || !self.password.blank? || !self.password_confirmation.blank?
  end

  def define_role
    if self.role.present?
      self.role = Ability::ROLES.include?(role.downcase.to_sym) ? role.downcase : Ability::ROLES[:read_only]
    else
      self.role = Ability::ROLES[:read_only]
    end
  end
end
