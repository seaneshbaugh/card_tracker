# frozen_string_literal: true

class ContactMailer < ActionMailer::Base
  default from: 'noreply@cavesofkoilos.com'

  def contact_form_message(user, contact)
    @user = user

    @contact = contact

    mail to: @user.email, subject: "New Message from #{@contact.email}"
  end

  def contact_form_confirmation_message(contact)
    @contact = contact

    mail to: @contact.email, subject: 'Thanks for your message!'
  end
end
