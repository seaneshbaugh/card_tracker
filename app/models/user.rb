# frozen_string_literal: true

class User < ApplicationRecord
  USERNAME_FORMAT = /\A[a-zA-Z]([a-zA-Z0-9_]){4,31}\z/.freeze

  has_many :card_lists, autosave: true, dependent: :destroy, inverse_of: :user
  has_many :collections, dependent: :destroy, inverse_of: :user
  has_many :cards, through: :collections, inverse_of: :users

  validates :username, format: { with: USERNAME_FORMAT }, length: { within: 5..32 }, presence: true, uniqueness: true
  validates :email, email: { allow_blank: true }, presence: true, uniqueness: { case_sensitive: false }

  after_initialize :set_default_attribute_values, if: :new_record?
  after_create :assign_default_role
  after_create :create_default_lists
  after_commit :send_registration_notifications, on: :create

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable, :timeoutable

  rolify

  def full_name
    "#{first_name} #{last_name}"
  end

  def default_list
    card_lists.find_by(default: true)
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  private

  def assign_default_role
    add_role(:user) if roles.blank?
  end

  def create_default_lists
    return unless card_lists.empty?

    CardList::DEFAULT_LISTS.each do |default_list|
      card_lists << CardList.new(default_list)
    end
  end

  def send_registration_notifications
    RegistrationNotificationJob.perform_later(self)
  end

  def set_default_attribute_values
    self.username ||= ''
    self.email ||= ''
    self.first_name ||= ''
    self.last_name ||= ''
    self.receive_newsletters = true if receive_newsletters.nil?
    self.receive_contact_alerts = false if receive_contact_alerts.nil?
    self.receive_sign_up_alerts = false if receive_sign_up_alerts.nil?
    self.sign_in_count ||= 0
  end
end
