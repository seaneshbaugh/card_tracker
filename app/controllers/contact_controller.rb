class ContactController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])

    if @contact.valid?
      @alert_recipients = User.where('`users`.`role` != ? AND `users`.`receive_contact_alerts` = ?', Ability::ROLES[:read_only], true)

      # Delayed Job doesn't quite work with my current host.

      @alert_recipients.each do |alert_recipient|
        #ContactMailer.delay(:run_at =>  1.minutes.from_now.getutc).new_contact_form_message(alert_recipient, @contact)

        ContactMailer.new_contact_form_message(alert_recipient, @contact).deliver
      end

      #ContactMailer.delay(:run_at =>  3.minutes.from_now.getutc).contact_form_confirmation_message(@contact)

      ContactMailer.contact_form_confirmation_message(@contact).deliver

      flash[:success] = 'Thanks for your message! We will get back to you soon.'

      render 'thanks'
    else
      render 'new'
    end
  end
end
