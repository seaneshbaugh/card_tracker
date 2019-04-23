# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    before_action :find_user, only: %i[show edit update destroy]

    authorize_resource

    def index
      @search = User.search(params[:q])

      @users = @search.result.order('`users`.`created_at` ASC').page(params[:page])
    end

    def show
      if @user.nil?
        flash[:error] = t('messages.users.could_not_find')

        redirect_to admin_users_url
      end
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(params[:user])

      @user.confirmed_at = Time.now.in_time_zone

      @user.role = Ability::ROLES[:read_only] if current_user.role != Ability::ROLES[:sysadmin] && @user.role == Ability::ROLES[:sysadmin]

      if @user.save
        flash[:success] = t('messages.users.created')

        redirect_to admin_users_url
      else
        flash.now[:error] = @user.errors.full_messages.uniq.join('. ') + '.'

        render 'new'
      end
    end

    def edit
      if @user.nil?
        flash[:error] = t('messages.users.could_not_find')

        redirect_to admin_users_url
      end
    end

    def update
      if @user.nil?
        flash[:error] = t('messages.users.could_not_find')

        redirect_to(admin_users_url) && return
      end

      params[:user][:role] = Ability::ROLES[:read_only] if params[:user] && current_user.role != Ability::ROLES[:sysadmin] && params[:user][:role] == Ability::ROLES[:sysadmin]

      if @user.update(params[:user])
        @user.confirm! if @user.unconfirmed_email.present?

        flash[:success] = t('messages.users.updated')

        redirect_to edit_admin_user_url(@user)
      else
        flash.now[:error] = @user.errors.full_messages.uniq.join('. ') + '.'

        render 'edit'
      end
    end

    def destroy
      if @user.nil?
        flash[:error] = t('messages.users.could_not_find')

        redirect_to(admin_users_url) && return
      end

      @user.destroy

      flash[:success] = t('messages.users.deleted')

      redirect_to admin_users_url
    end

    protected

    def find_user
      @user = User.where(id: params[:id]).first
    end
  end
end
