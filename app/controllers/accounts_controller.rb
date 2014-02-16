class AccountsController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @account = current_user
  end

  def update
    @account = current_user

    params[:account].delete(:role) if params[:account]

    params[:account].delete(:receive_sign_up_alerts) if params[:account]

    params[:account].delete(:receive_contact_alerts) if params[:account]

    if @account.update_attributes(params[:account])
      sign_in(@account, :bypass => true)

      flash[:success] = t('messages.accounts.updated')

      redirect_to edit_account_url
    else
      flash.now[:error] = @account.errors.full_messages.uniq.join('. ') + '.'

      render 'edit'
    end
  end

  def confirm_delete
    @account = User.where(:id => current_user.id).first
  end

  def destroy
    @account = User.where(:id => current_user.id).first

    @account.destroy

    flash[:success] = 'Your account has successfully been deleted.'

    redirect_to root_url
  end
end
