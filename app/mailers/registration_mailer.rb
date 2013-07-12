class RegistrationMailer < ActionMailer::Base
  default :from => 'noreply@cavesofkoilos.com'

  def new_sign_up_message(user, new_user)
    @user = user

    @new_user = new_user

    mail :to => @user.email, :from => 'Caves of Koilos Registration <registration@cavesofkoilos.com>', :subject => "#{@new_user.email} has created an account."
  end

  def welcome_message(new_user)
    @new_user = new_user

    mail :to => @new_user.email, :from => 'Sean from Caves of Koilos <sean@cavesofkoilos.com>', :subject => 'Keeping track of your Magic: The Gathering collection just got easier!'
  end
end
