# frozen_string_literal: true

class User < ApplicationRecord
  has_many :card_lists, autosave: true, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :cards, through: :collections

  validates :username, format: { with: /\A[a-z]([a-z0-9_]){4,31}\z/ }, length: { within: 5..32 }, presence: true, uniqueness: true
  validates :email, email: { allow_blank: true }, presence: true, uniqueness: { case_sensitive: false }

  after_create :assign_default_role
  after_create :create_default_lists
  after_commit :send_registration_notifications, on: :create

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable, :timeoutable

  rolify

  resourcify :other_users

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
end
