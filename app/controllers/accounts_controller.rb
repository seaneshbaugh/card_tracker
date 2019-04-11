class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update confirm_destroy destroy]

  before_filter :authenticate_user!

  def show; end

  def edit; end

  def update
    if @account.update(account_params)
      bypass_sign_in(@account)

      flash[:success] = t('.success')

      redirect_to edit_account_url, status: :see_other
    else
      flash.now[:error] = helpers.error_messages_for(@account)

      render 'edit', status: :unprocessable_entity
    end
  end

  def confirm_destroy; end

  def destroy
    @account.destroy

    flash[:success] = t('.success')

    redirect_to root_url, status: :see_other
  end

  private

  def set_account
    @account = current_user
  end

  def account_params
    params.require(:account).permit(:username, :email, :password, :password_confirmation, :first_name, :last_name)
  end
end
