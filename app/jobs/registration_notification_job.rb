# frozen_string_literal: true

class RegistrationNotificationJob < ApplicationJob
  queue_as :registration_notification

  def perform(user)
    notification_recipients.each do |notification_recipient|
      RegistrationMailer.new_sign_up_message(notification_recipient, user).deliver
    end

    RegistrationMailer.welcome_message(user).deliver
  end

  private

  def notification_recipients
    User.with_role(:admin).where(receive_sign_up_alerts: true)
  end
end
