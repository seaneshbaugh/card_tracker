class ContactMailer < ActionMailer::Base
  default :from => 'noreply@cavesofkoilos.com'

  def new_contact_form_message(user, contact)
    @user = user

    @contact = contact

    mail :to => user.email, :subject => "The Caves of Koilos Contact Form - #{@contact.subject}"
  end
end
