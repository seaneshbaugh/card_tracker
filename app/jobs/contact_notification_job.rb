# frozen_string_literal: true

class ContactNotificationJob < ApplicationJob
  queue_as :contact

  def perform(contact_hash)
    contact = Contact.new(JSON.parse(contact_hash))

    notification_recipients.each do |notification_recipient|
      ContactMailer.contact_form_message(notification_recipient, contact).deliver
    end

    ContactMailer.contact_form_confirmation_message(contact).deliver
  end

  # TODO: Uncomment this and delete the above method when Rails 6 is released.
  # def perform(contact)
  #   notification_recipients.each do |notification_recipient|
  #     ContactMailer.contact_form_message(notification_recipient, contact).deliver
  #   end

  #   ContactMailer.contact_form_confirmation_message(contact).deliver
  # end

  private

  def notification_recipients
    User.with_role(:admin).where(receive_contact_alerts: true)
  end
end
