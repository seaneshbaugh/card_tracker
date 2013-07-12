class ContactMailer < ActionMailer::Base
  default :from => 'noreply@cavesofkoilos.com'

  def new_contact_form_message(user, contact)
    @user = user

    @contact = contact

    mail :to => @user.email, :from => 'Caves of Koilos Contact Form <contact@cavesofkoilos.com>', :subject => "New Message from #{@contact.email}"
  end

  def contact_form_confirmation_message(contact)
    @contact = contact

    mail :to => @contact.email, :from => 'Sean from Caves of Koilos <sean@cavesofkoilos.com>', :subject => 'Thanks for your message!'
  end
end
