# frozen_string_literal: true

class RegistrationMailer < ActionMailer::Base
  default from: 'noreply@cavesofkoilos.com'

  def new_sign_up_message(user, new_user)
    @user = user
    @new_user = new_user

    mail to: @user.email, subject: "#{@new_user.email} has created an account."
  end

  def welcome_message(new_user)
    @new_user = new_user

    mail to: @new_user.email, subject: 'Keeping track of your Magic: The Gathering collection is about to get easier!'
  end
end
