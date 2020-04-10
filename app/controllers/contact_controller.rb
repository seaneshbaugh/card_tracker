# frozen_string_literal: true

class ContactController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    # @contact = Contact.new(contact_params).sanitize!

    # if @contact.valid?
    #   ContactNotificationJob.perform_later(@contact)

    render 'thanks'
    # else
    #   flash.now[:error] = helpers.error_messages_for(@contact)

    #   render 'new', status: :unprocessable_entity
    # end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :body)
  end
end
