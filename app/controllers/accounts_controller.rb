class AccountsController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @account = User.where(:id => current_user.id).first
  end

  def update
    @account = User.where(:id => current_user.id).first

    params[:account].delete(:role) if params[:account]

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

    #@account.destroy

    redirect_to root_url
  end
end
