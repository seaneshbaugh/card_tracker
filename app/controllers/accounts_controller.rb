# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    @account = current_user
  end

  def edit
    @account = current_user
  end

  def update
    @account = current_user

    if @account.update(account_params)
      bypass_sign_in(@account)

      flash[:success] = t('.success')

      redirect_to edit_account_url, status: :see_other
    else
      flash.now[:error] = helpers.error_messages_for(@account)

      render 'edit', status: :unprocessable_entity
    end
  end

  def confirm_delete
    @account = current_user
  end

  def destroy
    @account = current_user

    @account.destroy

    flash[:success] = t('.success')

    redirect_to root_url, status: :see_other
  end

  private

  def account_params
    params.require(:account).permit(:username, :email, :password, :password_confirmation, :first_name, :last_name, :receive_newsletters)
  end
end
