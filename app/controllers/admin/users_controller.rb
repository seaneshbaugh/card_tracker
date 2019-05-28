# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    def index
      authorize User

      @search = User.ransack(params[:q])
      @users = @search.result.display_order.page(params[:page])
    end

    def show
      @user = find_user

      authorize @user
    end

    def new
      authorize User

      @user = User.new
    end

    def create
      authorize User

      @user = User.new(user_params)
      @user.confirmed_at = Time.now.in_time_zone

      if @user.save
        flash[:success] = t('.success')

        redirect_to admin_user_url(@user), status: :see_other
      else
        flash.now[:error] = helpers.error_messages_for(@user)

        render 'new', status: :unprocessable_entity
      end
    end

    def edit
      @user = find_user

      authorize @user
    end

    def update
      @user = find_user

      authorize @user

      if @user.update(user_params)
        @user.confirm! if @user.unconfirmed_email.present?

        flash[:success] = t('.success')

        redirect_to edit_admin_user_url(@user), status: :see_other
      else
        flash.now[:error] = helpers.error_messages_for(@user)

        render 'edit', status: :unprocessable_entity
      end
    end

    def destroy
      @user = find_user

      authorize @user

      @user.destroy

      flash[:success] = t('.success')

      redirect_to admin_users_url, status: :see_other
    end

    protected

    def find_user
      User.find_by!(id: params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :first_name, :last_name, :roles)
    end
  end
end
