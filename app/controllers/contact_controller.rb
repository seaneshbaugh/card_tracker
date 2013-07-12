class ContactController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])

    if @contact.valid?
      @alert_recipients = User.where('users.role != ? AND users.receive_contact_alerts = ?', Ability::ROLES[:read_only], true)

      @alert_recipients.each do |alert_recipient|
        ContactMailer.delay.new_contact_form_message(alert_recipient, @contact)
      end

      ContactMailer.delay(:run_at =>  3.minutes.from_now.getutc).contact_form_confirmation_message(@contact)

      flash[:success] = 'Thanks for your message! We will get back to you soon.'

      redirect_to root_url
    else
      render 'new'
    end
  end
end
